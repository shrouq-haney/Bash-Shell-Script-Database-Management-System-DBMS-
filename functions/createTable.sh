#!/bin/bash

function createTable {
    clear
    echo "==========================================================================================================================================================="
    echo ""
    echo "                                                           ➕ Create Tables in $dbname  ➕"
    echo ""
    echo "==========================================================================================================================================================="

    while true; do 
        read -p "Enter table name or type 'exit':) " tablename
        if [[ $tablename == "exit" ]]; then
            TablesMainMenu
            return
        fi
         validatetablename "$tablename"
        if [[ $? -ne 0 ]]; then
            continue  
        fi


        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ -f "$TABLE_PATH" ]]; then
            echo -e "${RED_CRIMSON}❌  Table '$tablename' already exists!${NC}"
            continue
        fi

        read -p "Enter number of columns: " col_count
        if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
            echo -e "${RED_CRIMSON}❌ Column Count must be int!${NC}"
            continue
        fi


        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$TABLE_PATH"
        echo "<Table name=\"$tablename\">" >> "$TABLE_PATH"
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$META_PATH"
        echo "<TableMeta name=\"$tablename\">" >> "$META_PATH"
        echo "  <Columns count=\"$col_count\">" >> "$META_PATH"

        declare -A column_names  
        primary_key_count=0  

        for ((j = 1; j <= col_count; j++)); do
            col_name=""
            col_type=""

            while true; do
                read -p "Enter column name: " col_name
                validateColumnname "$col_name"
		if [[ $? -ne 0 ]]; then
		    continue  
		fi
           
                read -p "Data Type (string/int): " col_type
                if [[ "$col_type" =~ ^(string|int)$ ]]; then
                    break
                else
                    echo -e "${RED_CRIMSON}❌ Invalid choice, please enter 'string' or 'int' ${NC}"
                fi
            done

            read -p "Is this the Primary Key? (Y/N): " is_pk
            if [[ "$is_pk" =~ ^[Yy]$ ]]; then
                is_pk="true"
                ((primary_key_count++))
            else
                is_pk="false"
            fi

            read -p "Unique? (Y/N): " is_unique
            [[ "$is_unique" =~ ^[Yy]$ ]] && is_unique="true" || is_unique="false"

            read -p "Nullable? (Y/N): " is_nullable
            [[ "$is_nullable" =~ ^[Yy]$ ]] && is_nullable="true" || is_nullable="false"

            echo "<Column name=\"$col_name\" type=\"$col_type\" primaryKey=\"$is_pk\" unique=\"$is_unique\" nullable=\"$is_nullable\" />" >> "$META_PATH"
        done

        if [[ "$primary_key_count" -eq 0 ]]; then
            echo -e "${RED_CRIMSON}❌ Error: No Primary Key defined! you must insert PK ${NC}"
            echo -e "${BLUE_OCEAN}ℹ️ Table creation canceled${NC}" && rm -f "$TABLE_PATH" "$META_PATH" 
            read -p "enter any key to insert another table:)" enter && createTable
        fi

        echo "  </Columns>" >> "$META_PATH"
        echo "</TableMeta>" >> "$META_PATH"
        echo "</Table>" >> "$TABLE_PATH"

        echo -e "${GREEN}✅ Table '$tablename' created successfully 🎉${NC}"

        while true; do
            read -p "Do you want to return to the main menu (1) or add another table (2)? " choice
            case $choice in
                1) TablesMainMenu ;;   
                2) createTable ; break ;;  
                *) echo -e "${RED_CRIMSON}❌ Invalid choice! Please enter 1 or 2.${NC}" ;;
            esac
        done

    done
}

