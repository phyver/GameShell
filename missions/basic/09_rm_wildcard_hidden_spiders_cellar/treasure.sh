# NOTE: --literal doesn't exist in freebsd
if ls --literal / &> /dev/null
then
    alias ls='ls --literal -p'
else
    alias ls='ls -p'
fi
