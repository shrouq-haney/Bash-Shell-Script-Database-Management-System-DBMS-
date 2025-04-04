#!/bin/bash

function selectDB {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "    								 🔗 CONNECT TO DATABASE  🔗  "
    echo ""
    echo "============================================================================================================================================================"
    echo "🗃️  Available databases:)"
    echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"
    ls -1 "$DB_MAIN_DIR"| awk '{print "📂 " $0}'

    while true; do
        read -p "Enter database name or type  'exit' to return:) " dbname

        if [[ $dbname == "exit" ]]; then

            dbMainMenu
            return
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            continue
        fi

        if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            echo -e "${GREEN}✅ Successfully connected to '$dbname'! 🎉 ${NC}"

            TablesMainMenu
            return
        else
            echo -e "${RED_CRIMSON}❌ Error: Database '$dbname' does not exist.${NC}"
             read -p "do you went create new Datebase? (Y/N): " to_create
            [[ "$to_create" =~ ^[Yy]$ ]] && to_create= createDB 
        fi
    done
}

