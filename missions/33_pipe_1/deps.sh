if ! command -v python3 > /dev/null; then
    echo "Attention, la commande python3 n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet python3"
    exit 1
fi
