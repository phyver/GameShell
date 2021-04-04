p=$(ps | grep "gros_minet.sh$" | sed 's/^ *//' | cut -f1 -d" ")
ps -o pid,comm,ppid | grep "$p$" | grep "chat" | sed 's/^ *//' | cut -f1 -d" " | xargs kill
rm ~/Chateau/Cave/.*_chat
unset p
gash check

