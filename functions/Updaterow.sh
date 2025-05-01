#!/bin/bash

function UpdateTable {
    clear
    echo "==========================================================================================================================================================="
    echo ""
    echo "  							✏️  Update Data in Table - $dbname ✏️"
    echo ""
    echo "==========================================================================================================================================================="

    while true; do
        echo "📌 Available Tables in '$dbname':"
        echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
        ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄 " $0}'
        echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
        read -p "Enter table name: " tablename
        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ ! -f "$TABLE_PATH" ]]; then
            echo "❌ Table '$tablename' does not exist!"
            continue
        fi
        break
    done

    column_names=()
    column_types=()
    primary_key=""

    while read -r line; do
        col_name=$(echo "$line" | grep -oP 'name="\K[^"]+')
        col_type=$(echo "$line" | grep -oP 'type="\K[^"]+')
        is_primary=$(echo "$line" | grep -oP 'primaryKey="\K[^"]+')

        if [[ -n "$col_name" && "$col_name" != "$tablename" ]]; then
            column_names+=("$col_name")
            column_types+=("$col_type")
            [[ "$is_primary" == "true" ]] && primary_key="$col_name"
        fi
    done < "$META_PATH"

    if [[ -z "$primary_key" ]]; then
        echo "❌ No primary key defined!"
        return
    fi

    echo "🔍 Columns in '$tablename':"
    printf "📌 %-15s | %-10s\n" "Column" "Type"
    printf "%-17s|%-12s\n" "-----------------" "------------"
    for i in "${!column_names[@]}"; do
        printf "   %-15s | %-10s\n" "${column_names[$i]}" "${column_types[$i]}"
    done

    # Loop until a valid row is found
    while true; do
        read -p "Enter value of Primary Key ($primary_key) to update: " pk_value

        # Extract row using awk — only row that matches the primary key
        row=$(awk -v pk="$pk_value" -v key="$primary_key" '
            BEGIN { RS="</Row>"; ORS="" }
            $0 ~ "<"key">"pk"</"key">" {
                print $0"</Row>"
            }
        ' "$TABLE_PATH")

        if [[ -z "$row" ]]; then
            echo "❌ No row found with $primary_key = $pk_value"
            echo "1) Try again"
            echo "2) Exit to Main Menu"
            read -p "Enter your choice: " choice
            case $choice in
                1)
                    clear  
                    echo "❌ No row found with $primary_key = $pk_value" 
                    continue  
                    ;;
                2)
                    clear
                    echo "❌ Exiting to Main Menu..."
                    TablesMainMenu
                    return
                    ;;
                *)
                    echo "❌ Invalid choice. Please enter 1 or 2."
                    ;;
            esac
        else
            break
        fi
    done

    echo "✅ Row found:"
    echo "$row" | sed -E 's/<\/?Row>//g' | grep -oP '<[^>]+>[^<]+</[^>]+>' | while read -r line; do
        key=$(echo "$line" | grep -oP '^<\K[^>]+')
        value=$(echo "$line" | grep -oP '>\K[^<]+')
        echo "🔸 $key : $value"
    done

    echo -e "\n🛠 Available columns for update:"
    printf "%-17s|%-12s\n" "-----------------" "------------"
    printf "   %-15s | %-10s\n" "Column" "Type"
    printf "%-17s|%-12s\n" "-----------------" "------------"
    for i in "${!column_names[@]}"; do
        if [[ "${column_names[$i]}" != "$primary_key" ]]; then
            printf "   %-15s | %-10s\n" "${column_names[$i]}" "${column_types[$i]}"
        fi
    done

    while true; do
        read -p "Enter column name to update: " col_to_update
        # Validation
        valid_col=false
        for name in "${column_names[@]}"; do
            if [[ "$name" == "$col_to_update" && "$name" != "$primary_key" ]]; then
                valid_col=true
                break
            fi
        done

        if [[ "$valid_col" != true ]]; then
            echo "❌ Invalid column!"

            # Give user the option to try again or exit
            echo "1) Try again"
            echo "2) Exit to Main Menu"
            read -p "Enter your choice: " choice
            case $choice in
                1)
                    clear
                    echo "❌ Invalid column!" 
                    echo "🛠 Available columns for update:"
                    echo "-----------------|------------"
                    for i in "${!column_names[@]}"; do
                        if [[ "${column_names[$i]}" != "$primary_key" ]]; then
                            printf "   %-15s | %-10s\n" "${column_names[$i]}" "${column_types[$i]}"
                        fi
                    done
                    continue
                    ;;
                2)
                    clear
                    echo "❌ Exiting to Main Menu..."
                    TablesMainMenu
                    return
                    ;;
                *)
                    echo "❌ Invalid choice. Please enter 1 or 2."
                    ;;
            esac
        else
            break
        fi
    done

    idx=-1
    for i in "${!column_names[@]}"; do
        [[ "${column_names[$i]}" == "$col_to_update" ]] && idx=$i && break
    done
    type="${column_types[$idx]}"

    old_val=$(echo "$row" | grep -oP "<$col_to_update>\K[^<]+")
    echo "🔍 Current value for '$col_to_update': $old_val"
    read -p "Enter new value: " new_val

    if [[ "$type" == "int" && ! "$new_val" =~ ^[0-9]+$ ]]; then
        echo "❌ Invalid input: Expected an integer!"
        return
    fi
    if [[ "$type" == "string" && -z "$new_val" ]]; then
        echo "❌ Invalid input: String cannot be empty!"
        return
    fi

    new_row=$(echo "$row" | sed "s|<$col_to_update>$old_val</$col_to_update>|<$col_to_update>$new_val</$col_to_update>|")

    # Replace old row with new row safely
    tmp_file=$(mktemp)
    awk -v old="$row" -v new="$new_row" '
        BEGIN { RS="</Row>"; ORS="" }
        {
            if ($0 "</Row>" == old) {
                print new
            } else {
                print $0"</Row>"
            }
        }
    ' "$TABLE_PATH" > "$tmp_file" && mv "$tmp_file" "$TABLE_PATH"

    echo -e "\n✅ Successfully updated '$col_to_update' to '$new_val'!"


    while true; do
        read -p "Do you want to return to the main menu (1) or update another row (2)? " choice
        case $choice in
            1) 
                TablesMainMenu
                return
                ;;
            2) 
                UpdateTable
                return
                ;;
            *)
                echo -e "❌ Invalid choice! Please enter 1 or 2."
                ;;
        esac
    done
}

