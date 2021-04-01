p=$(ps | grep "gros_minet.sh$" | cut -f1 -d" ")
ps -o pid,comm,ppid | grep "$p$" | grep "chat" | cut -f1 -d" " | xargs kill
rm ~/Chateau/Cave/.*_chat
unset p
gash check

