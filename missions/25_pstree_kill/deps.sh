if ! command -v pstree > /dev/null; then
    echo "Attention, la commande pstree n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet psmisc"
    exit 1
fi
