if ! command -v gcc > /dev/null && ! command -v clang && ! command -v cc && ! command -v python3 > /dev/null ; then
    echo "Attention, je n'ai trouvé ni Python3 ni un compilateur C."
    echo "La mission $_MISSION_NB ne sera pas faite"
    echo "sous Debian / Ubuntu, il faut installer un des paquets python3, gcc, ou clang"
    exit 1
fi
