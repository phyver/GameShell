# NOTE: --literal doesn't exist in freebsd
if ls --literal / &> /dev/null
then
    alias la='ls --literal -A'
else
    alias la='ls -A'
fi
