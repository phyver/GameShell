if ! command -v nano > /dev/null; then
    echo "Attention, la commande nano n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet nano"
    exit 1
fi
