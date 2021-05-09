from debian:stable

RUN apt update
RUN apt install --no-install-recommends --assume-yes \
    gettext-base \
    python3 \
    man-db \
    psmisc \
    nano tree \
    bsdmainutils \
    x11-apps
 RUN rm -rf /var/lib/apt/lists/*

## Set user and group
ARG user=gsh-user
ARG group=gsh-user
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory

## Switch to user
USER ${uid}:${gid}

WORKDIR /home/${user}

## use the latest github version
# ADD --chown=gsh-user:gsh-user https://api.github.com/repos/phyver/GameShell/tarball GameShell.tgz
# RUN mkdir GameShell
# RUN tar -xzf GameShell.tgz -C GameShell --strip-components 1
# RUN rm -f GameShell.tgz
# RUN GameShell/bin/archive.sh
# RUN rm -rf GameShell

## if you want to copy a local, customized version, comment the preceeding
## lines and uncomment the next one
COPY GameShell.sh .

ENTRYPOINT ["./GameShell.sh"]
