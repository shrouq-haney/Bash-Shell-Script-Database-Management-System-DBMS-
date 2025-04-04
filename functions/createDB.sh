#!/bin/bash

function createDB {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "    									 ➕  CREATE A NEW DATABASE  ➕ "
    echo ""
    echo "============================================================================================================================================================"

    while true; 
    do
        read -p "Enter the database name or type  'exit' to return:) " dbname

        if [[ $dbname == "exit" ]]; then
            dbMainMenu
            return
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            continue  
        fi

        if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            echo -e "${RED_CRIMSON}❌ Error: Database '$dbname' already exists.${NC}"
            continue
        fi
	
        mkdir "$DB_MAIN_DIR/$dbname"
        echo -e "${GREEN}✅ Database '$dbname' has been created successfully! 🎉${NC}"
        continue
    done
}
