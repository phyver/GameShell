#!/bin/bash
YELLOW='\033[1;33m'
NC='\033[0m'
arrow="--->>>"
cols=$(tput cols)

for ((i=0; i<cols-10; i++)); do
    printf "\r%*s" $i ""
    echo -ne "${YELLOW}${arrow}${NC}"
    sleep 0.02
done
echo -e "\n${YELLOW}💥 La flèche jaune frappe avec éclat !${NC}"

