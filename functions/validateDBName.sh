#!/bin/bash

function validateDBName {
    local dbname="$1"

    if [[ -z $dbname ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Database name cannot be empty.${NC}"
        return 1
    fi
    
    if [[ $dbname == *" "* ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Database name cannot contain spaces.${NC}"
        return 1
    fi

    if [[ $dbname == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Database name cannot contain special characters.${NC}"
        return 1
    fi
 
    if [[ $dbname =~ ^[0-9] ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Database name cannot start with a number.${NC}"
        return 1
    fi

    return 0  
}

