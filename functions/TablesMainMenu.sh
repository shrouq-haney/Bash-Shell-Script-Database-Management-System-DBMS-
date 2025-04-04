#! /bin/bash

function TablesMainMenu {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "      						 📂      WELCOME TO $dbname Database      📂"
    echo ""
    echo "============================================================================================================================================================"

    while true; do
        PS3="🔹 Enter your choice: "  
        options=(
            "➕ Create Table" 
            "📜 List Tables" 
            "❌ Drop Table" 
            "📥 Insert into Table" 
            "🔎 Select from Table" 
            "🗑️ Delete from Table" 
            "✏️ Update Table" 
            "🛠️ alterTable"
            "↩️ Go back to Database Main Menu"
        )

        select choice in "${options[@]}"; do
            case $REPLY in
                1) createTable; break ;;  
                2) ListTable; break ;;  
                3) DropTable; break ;;  
                4) insertTable; break ;;  
                5) selectFromTable; break ;;  
                6) deleteFromTable; break ;; 
                7) UpdateTable; break ;;
                8) alterTable ; break ;;
                9) dbMainMenu; break ;; 
                *) echo -e "${RED_CRIMSON}❌  Invalid option! Please select a number from 1 to 8. ${NC}" ;;
            esac
        done
    done
}

