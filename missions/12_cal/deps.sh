if ! command -v cal > /dev/null; then
    echo "Attention, la commande cal n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet bsdmainutils"
    exit 1
fi
