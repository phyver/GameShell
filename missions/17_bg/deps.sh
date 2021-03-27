if ! command -v xeyes > /dev/null; then
    echo "Attention, la commande xeyes n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet x11-apps"
    exit 1
fi
