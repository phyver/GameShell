from debian:stable

RUN apt update && apt install -y \
    psmisc \
    nano \
    tree \
    x11-apps \
    python3 \
    gcc \
    wget \
    procps \
    less \
 && rm -rf /var/lib/apt/lists/*

# Set user and group
ARG user=gash-user
ARG group=gash-user
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory

# Switch to user
USER ${uid}:${gid}

WORKDIR /home/${user}

RUN wget https://github.com/phyver/GameShell/raw/master/GameShell.tgz -O - | tar -xz

ENTRYPOINT ./GameShell/start.sh
