FROM ubuntu:20.04
ARG PUID=1000
ARG PGID=1000

RUN dpkg --add-architecture i386
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 gawk gcc net-tools \
    libncurses-dev libncurses5-dev zlib1g-dev zlib1g:i386 libssl-dev flex bison \
    xterm autoconf libtool texinfo gcc-multilib build-essential automake screen pax \
    g++ python3-pip xz-utils python3-git python3-jinja2 python3-pexpect \
    iputils-ping libegl1-mesa libsdl1.2-dev pylint3 python3 libtinfo5\
    cpio tftpd-hpa gnupg rsync bc ccache vim sudo locales locales-all

# set proper locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# not really necessary, just to make it easier to install packages on the run...
#RUN groupadd -g $PGID petalinux
#RUN if [ "$(id -G | grep -c $PGID)" -eq 0 ]; then groupadd -g $PGID petalinux; fi
RUN useradd -u $PUID -g $PGID -ms /bin/bash petalinux

USER petalinux
