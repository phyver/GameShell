cd ~/Echoppe
ls | grep -v "sans" | xargs grep -v "PAY" | wc -l | gash check
