if ! command -v gcc > /dev/null && ! command -v python3 > /dev/null ; then
    echo "Attention, ni la commande python3 ni la commande ne sont disponibles."
    echo "La mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer le paquet python3 et/ou gcc"
    exit 1
fi
