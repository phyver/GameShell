#!/bin/bash
BLUE='\033[0;34m'
NC='\033[0m'
arrow="--->>>"
cols=$(tput cols)

for ((i=0; i<cols-10; i++)); do
    printf "\r%*s" $i ""
    echo -ne "${BLUE}${arrow}${NC}"
    sleep 0.02
done
echo -e "\n${BLUE}💥 La flèche bleue transperce l’air !${NC}"

