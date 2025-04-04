#!/bin/bash

function selectFromTable {
    while true; do
        clear
   echo "============================================================================================================================================================"
        echo ""
        echo "						🔍 Select Data from Table in $dbname 🔍"
        echo ""
   echo "==========================================================================================================================================================="
        echo "📌 Available Tables in '$dbname':"
  echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"
        ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄 " $0}'
   echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"

        read -p "Enter table name or type 'exit' to go back:) " tablename
        if [[ "$tablename" == "exit" ]]; then
            TablesMainMenu
        fi

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ ! -f "$TABLE_PATH" || ! -f "$META_PATH" ]]; then
            echo -e "${RED_CRIMSON}❌  Table '$tablename' does not exist! ${NC}"
            read -p "Press Enter to continue..."
            continue
        fi

        column_names=()
        while IFS=' ' read -r line; do
            if [[ "$line" =~ name=\"([^\"]+)\" ]]; then
                column_names+=("${BASH_REMATCH[1]}")
            fi
        done < <(grep "<Column " "$META_PATH")

        if [[ ${#column_names[@]} -eq 0 ]]; then
            echo -e "${RED_CRIMSON}❌ Error: No columns found in '$tablename'! ${NC}"
            read -p "Press Enter to continue..."
            continue
        fi

  echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"
   echo "📌 Available Columns in '$tablename':"
   echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"
        for col in "${column_names[@]}"; do
            echo "  - $col"
        done
  echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"

        read -p "Do you want to filter by a specific column? (y/n): " filter_choice
        if [[ "$filter_choice" =~ ^[Yy]$ ]]; then
            read -p "Enter column name to filter by: " filter_col
            if [[ ! " ${column_names[@]} " =~ " $filter_col " ]]; then
                echo -e "${RED_CRIMSON}❌  Error: Column '$filter_col' not found! ${NC}"
                read -p "Press Enter to continue..."
                continue
            fi
            
            read -p "Enter value to filter by: " filter_value
    echo "==========================================================================================================================================================="
            echo "🔍 Results for '$filter_col = $filter_value' in '$tablename':"

            awk -v col="$filter_col" -v val="$filter_value" -v columns="$(IFS=,; echo "${column_names[*]}")" '
            BEGIN {
                RS="<Row>"; FS="\n"; found=0;
                split(columns, cols, ",");
                print "=======================================================";
                printf "|";
                for (i in cols) printf " %-15s |", cols[i];
                print "\n=======================================================";
            }
            {
                match($0, "<"col">"val"</"col">")
                if (RSTART) {
                    printf "|";
                    for (i in cols) {
                        field = cols[i];
                        value = "";
                        match($0, "<"field">[^<]+</"field">");
                        if (RSTART) {
                            value = substr($0, RSTART + length("<"field">"), RLENGTH - length("<"field">") - length("</"field">"));
                        }
                        printf " %-15s |", value;
                    }
                print "\n-------------------------------------------------------";
                    found=1;
                }
            }
            END {
                if (found==0) {
                    print "| ❌ No matching records found!                              |";
                print "========================================================";
                }
            }
            ' "$TABLE_PATH"

        else
    echo "==========================================================================================================================================================="
            echo "📄 All Data in '$tablename':"

            awk -v columns="$(IFS=,; echo "${column_names[*]}")" '
            BEGIN {
                RS="<Row>"; FS="\n"; found=0;
                split(columns, cols, ",");
                print "=======================================================";
                printf "|";
                for (i in cols) printf " %-15s |", cols[i];
                print "\n=======================================================";
            }
            NR>1 {
                printf "|";
                for (i in cols) {
                    field = cols[i];
                    value = "";
                    match($0, "<"field">[^<]+</"field">");
                    if (RSTART) {
                        value = substr($0, RSTART + length("<"field">"), RLENGTH - length("<"field">") - length("</"field">"));
                    }
                    if (value != "") {
                        printf " %-15s |", value;
                    } else {
                        printf " %-15s |", "N/A";
                    }
                }
                print "\n-------------------------------------------------------";
                found=1;
            }
            END {
                if (found==0) {
                    print "| ❌ No data available in the table!                          |";
                    print "=======================================================";
                }
            }
            ' "$TABLE_PATH"
        fi

    echo "==========================================================================================================================================================="
        read -p "Press Enter to continue..."
    done
}

