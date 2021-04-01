grep -Zvl "sans" ~/Echoppe/* | xargs -0 grep -v "PAY" | wc -l | gash check
