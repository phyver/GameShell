if ! command -v gcc > /dev/null; then
    echo "Attention, la commande gcc n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet gcc"
    exit 1
fi
