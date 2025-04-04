#! /bin/bash

function alterTable {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "                                                      🛠️  Alter Table in $dbname  🛠️"
    echo ""
    echo "============================================================================================================================================================"
    echo "📌 Available Tables in $dbname :)   "
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
    ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//'| awk '{print "📄 " $0}'  
    echo "-----------------------------------------------------------------------------------------------------------------------------------------------------------"
    while true; do
        echo "📌 Available tables in '$dbname':"
        tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄 " $0}')
        
        if [[ -z "$tables" ]]; then
            echo -e "${RED_CRIMSON}❌ No tables found in '$dbname'! ${NC}"
            read -p "Press Enter to return to the main menu..." 
            TablesMainMenu
            return
        fi

        read -p "Enter table name or type 'exit' to go back:) " dtb
        [[ "$dtb" == "exit" ]] && TablesMainMenu && return

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$dtb.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${dtb}_meta.xml"

        if [[ ! -f "$TABLE_PATH" || ! -f "$META_PATH" ]]; then
            echo -e "${RED_CRIMSON}❌ Error: Table '$dtb' does not exist! ${NC}"
            continue
        fi

        while true; do
            echo "What do you want to do?"
            echo "1) Add a new column"
            echo "2) Delete an existing column"
            echo "3) Go back to table selection"
            read -p "Enter your choice or type 'exit' to return to main menu :) " choice

            [[ "$choice" == "exit" ]] && TablesMainMenu && return
            [[ "$choice" == "3" ]] && break

            case $choice in
                1) 
                    read -p "Enter new column name: " new_col
                    read -p "Enter default value (or leave empty): " default_value
                    
                
                    echo "    <Column name=\"$new_col\" type=\"string\" />" >> "$META_PATH"

                  
                    sed -i "/<\/Row>/ i\    <$new_col>$default_value</$new_col>" "$TABLE_PATH"

                    echo -e "${GREEN}✅ Column '$new_col' added successfully! 🎉 ${NC}"
                    ;;
                
                2) 
                    read -p "Enter column name to delete: " del_col
                    
                    if ! grep -q "<Column name=\"$del_col\"" "$META_PATH"; then
                        echo -e "${RED_CRIMSON}❌ Error: Column '$del_col' not found in table '$dtb'. ${NC}"
                        continue
                    fi

                  
                    sed -i "/<Column name=\"$del_col\"/d" "$META_PATH"

                 
                    sed -i "s/<$del_col>.*<\/$del_col>//g" "$TABLE_PATH"

                    echo -e "${GREEN}✅ Column '$del_col' deleted successfully! 🎉 ${NC}"
                    ;;
                
                *) 
                    echo -e "${RED_CRIMSON}❌ Invalid choice! ${NC}"
                    ;;
            esac
        done
    done
}

