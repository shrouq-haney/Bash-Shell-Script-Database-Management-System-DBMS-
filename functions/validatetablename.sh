#!/bin/bash

function validatetablename {
    local tablename="$1"

    if [[ -z $tablename ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Table name cannot be empty.${NC}"
        return 1
    fi

    if [[ $tablename == *" "* ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Table name cannot contain spaces.${NC}"
        return 1
    fi

    if [[ $tablename == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Table name cannot contain special characters.${NC}"
        return 1
    fi

    if [[ $tablename =~ ^[0-9] ]]; then
        echo -e "${RED_CRIMSON}❌  Error: Table name cannot start with a number.${NC}"
        return 1
    fi

    return 0  
}

