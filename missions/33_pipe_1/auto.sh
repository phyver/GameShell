cd ~/Echoppe
grep -Zv "sans" ./* | xargs -0 grep "Duc " | grep -v "PAY" | grep -o "[0-9]* *piécettes.$" | awk '{s+=$1} END{print s}' | gash check
