if ! command -v tree > /dev/null; then
    echo "Attention, la commande tree n'est pas installée, la mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet tree"
    exit 1
fi
