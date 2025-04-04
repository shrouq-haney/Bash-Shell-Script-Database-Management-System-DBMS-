#!/bin/bash
function renameDB {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "         								✏️  RENAME DATABASE ✏️"
   echo ""
    echo "============================================================================================================================================================"

    while true; do
        read -p "Enter the  database name or 'exit' to return :) " old_name

        if [[ $old_name == "exit" ]]; 
        then
            dbMainMenu
            return
        fi

        if [[ ! -d "$DB_MAIN_DIR/$old_name" ]]; 
        then
            echo -e "${RED_CRIMSON}❌ Error: Database '$old_name' does not exist! ${NC}"
            continue
        fi

        read -p "Enter the new database name:) " new_name

        validateDBName "$new_name"
        if [[ $? -ne 0 ]]; 
        then
            continue
        fi
        
        if [[ -d "$DB_MAIN_DIR/$new_name" ]]; 
        then
            echo -e "${RED_CRIMSON}❌ Error: Database '$new_name' already exists! ${NC}"
            continue
        fi
        mv "$DB_MAIN_DIR/$old_name" "$DB_MAIN_DIR/$new_name"
        
        echo -e "${GREEN}✅ Database renamed successfully from '$old_name' to '$new_name'! 🎉 ${NC}"
        continue
        
    done
}

