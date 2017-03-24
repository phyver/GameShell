cd ~/Echoppe
ls | grep -v "sans" | xargs grep "Duc " | grep -v "PAY" | grep -o "[0-9]* *piécettes.$" | awk '{s+=$1} END{print s}' | gash check
