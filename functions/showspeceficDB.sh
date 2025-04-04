#!/bin/bash

function SpecificDB {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "  								🔍   SEARCH FOR A DATABASE      🔍"
    echo ""
    echo "============================================================================================================================================================"

    while true; do
        read -p "🔹 Enter the database name or type  'exit' to return: " dbname
        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; 
        then
            continue
        fi


        if [[ "$dbname" == "exit" ]]; then
            dbMainMenu
        elif [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            echo "--------------------------------------------------------------------------------------------------------------------------------------------"
            echo "📂 Contents of $dbname:)"
            echo "--------------------------------------------------------------------------------------------------------------------------------------------"
            ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄 " $0}'
            read -p "do you went connect [$dbname] Database? (Y/N): " to_connect
            [[ "$to_connect" =~ ^[Yy]$ ]] && to_connect= TablesMainMenu 
        else
            echo -e "${RED_CRIMSON}❌  Error: The database '$dbname' was not found.${NC}"
        fi
    done
}

