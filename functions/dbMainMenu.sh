#!/bin/bash
function dbMainMenu {
    clear
    echo "============================================================================================================================================================"
    echo ""
    echo "								🚀    WELCOME TO THE DATABASE MAIN MENU    🚀"
    echo ""
    echo "============================================================================================================================================================"
    echo "📌 Please choose an option from the menu below :)"
    echo "------------------------------------------------------------------------------------------------------------------------------------------------------------"

    while true; do
        PS3="🔹 Enter your choice: "  
        options=(
            "📂 Select Database" 
            "➕ Create Database" 
            "✏️  Rename Database" 
            "🗑️  Drop Database" 
            "🗃️ Show Databases" 
            "💻 Execute SQL Query" 
            "❌ Exit"
        )

        select choice in "${options[@]}"; do
            case $REPLY in
                1) selectDB; break ;;  
                2) createDB; break ;;  
                3) renameDB; break ;;  
                4) dropDB; break ;;  
                5) showDBs; break ;;  
                6) executeSQL; break ;;  
                7) echo -e "👋 Exiting, Goodbye :("; exit 0 ;;  
                *) echo -e "${RED_CRIMSON}❌ Invalid option! Please select a valid number from 1 to 7.${NC}" ;;
            esac
        done
    done
}

