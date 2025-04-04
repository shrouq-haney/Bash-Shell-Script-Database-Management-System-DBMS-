#!/bin/bash

function UpdateTable {
    clear
    echo "==========================================================================================================================================================="
    echo ""
    echo "  							✏️  Update Data in Table - $dbname ✏️"
    echo ""
    echo "==========================================================================================================================================================="
    echo "📌 Available Tables in '$dbname':)"
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
    ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄 " $0}'
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"

    while true; do
        read -p "Enter table name:) " tablename
        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ ! -f "$TABLE_PATH" ]]; then
            echo -e "${RED_CRIMSON}❌  Table '$tablename' does not exist! ${NC}"
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

        if [[ -n "$col_name" && "$col_name" != "em" ]]; then 
            column_names+=("$col_name")
            column_types+=("$col_type")
            [[ "$is_primary" == "true" ]] && primary_key="$col_name"
        fi
    done < "$META_PATH"

    echo "🔍 Extracted Column Data:"
    for i in "${!column_names[@]}"; do
        echo "📌 Column: ${column_names[$i]} | Type: ${column_types[$i]}"
    done
    echo "➡️ Primary Key Extracted: $primary_key"

    if [[ -z "$primary_key" ]]; then
        echo -e "${RED_CRIMSON}❌  Error: No primary key found in '$tablename'! ${NC}"
        return
    fi

    read -p "Enter value of Primary Key ($primary_key) to update: " pk_value

    old_value=$(grep -oP "<Row>.*<id>$pk_value<\/id>.*<name>\K[^<]+" "$TABLE_PATH")

    if [[ -z "$old_value" ]]; then
        echo -e "${RED_CRIMSON}❌ Error: No matching row found for PK = $pk_value ${NC}"
        echo "Here are the rows in the table to help you identify the issue:"
        grep -oP "<Row>.*</Row>" "$TABLE_PATH"
        return
    fi

    echo "📌 Available columns for update (except primary key):"
    for col in "${column_names[@]}"; do
        if [[ "$col" != "$primary_key" ]]; then
            echo "📄 $col"
        fi
    done

    read -p "Enter the column name you want to update: " col_name


    if [[ ! " ${column_names[@]} " =~ " $col_name " ]]; then
        echo -e "${RED_CRIMSON}❌ Error: Column '$col_name' does not exist! ${NC}"
        return
    fi


    old_value=$(grep -oP "<Row>.*<id>$pk_value<\/id>.*<$col_name>\K[^<]+" "$TABLE_PATH")


    if [[ -z "$old_value" ]]; then
        old_value="N/A" 
    fi

    echo "📌 Current value for $col_name (old value): $old_value"
    

    read -p "Enter new value for $col_name (press Enter to keep the old value): " new_value
    [[ -z "$new_value" ]] && new_value="$old_value"


    col_type=$(echo "${column_types[@]}" | grep -oP "(?<=\b$col_name\b)[^ ]+")


    if [[ "$col_type" == "int" && ! "$new_value" =~ ^[0-9]+$ ]]; then
        echo -e "${RED_CRIMSON}❌ Error: Invalid value for column '$col_name' (expected type: int) ${NC}"
        return
    elif [[ "$col_type" == "string" && -z "$new_value" ]]; then
        echo -e "${RED_CRIMSON}❌ Error: Invalid value for column '$col_name' (expected type: string) ${NC}"
        return
    fi


    sed -i "s|<Row>.*<id>$pk_value</id>.*<$col_name>$old_value</$col_name>.*|<Row><id>$pk_value</id><$col_name>$new_value</$col_name></Row>|" "$TABLE_PATH"


    updated_value=$(grep -oP "<Row>.*<id>$pk_value<\/id>.*<$col_name>\K[^<]+" "$TABLE_PATH")

    echo "📌 Updated value for $col_name: $updated_value"
    echo -e "${GREEN} ✅ Row with PK = $pk_value has been successfully updated! Old value was '$old_value', new value is '$new_value'. 🎉 ${NC}"


    while true; do
        read -p "Do you want to return to the main menu (1) or update another row (2)? " choice
        case $choice in
            1) TablesMainMenu; return ;;  
            2) UpdateTable;;  
            *) echo -e "${RED_CRIMSON}❌ Invalid choice! Please enter 1 or 2. ${NC}" ;;
        esac
    done
}

