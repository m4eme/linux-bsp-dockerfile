FROM ubuntu:20.04 AS mw_petalinux_base
ARG PUID=1000
ARG PGID=1000
ARG PETALINUX_INSTALLATION_DIR=/opt/Xilinx/petalinux/2022.2

RUN dpkg --add-architecture i386
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y iproute2 gawk python3 python build-essential \
		gcc git make net-tools libncurses5-dev tftpd zlib1g-dev libssl-dev flex bison \
		libselinux1 gnupg wget git-core diffstat chrpath socat xterm autoconf libtool tar \
		unzip texinfo zlib1g-dev gcc-multilib automake zlib1g:i386 screen pax gzip cpio \
		python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git \
		python3-jinja2 libegl1-mesa libsdl1.2-dev bc pylint3 rsync lsb-release vim locales \
		locales-all libtinfo5

# set proper locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# set bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

# not really necessary, just to make it easier to install packages on the run...
RUN useradd -u $PUID -g $PGID -ms /bin/bash petalinux
RUN echo "root:peta" | chpasswd

RUN mkdir -p ${PETALINUX_INSTALLATION_DIR}
RUN chown $PUID:$PGID ${PETALINUX_INSTALLATION_DIR}
VOLUME /work

USER petalinux


FROM mw_petalinux_base AS mw_petalinux_install
ARG PETALINUX_INSTALLER=petalinux-v2022.2-10141622-installer.run
USER root
RUN mkdir /tmp/petalinux_installer
RUN chown $PUID:$PGID /tmp/petalinux_installer
USER petalinux
WORKDIR /tmp/petalinux_installer
COPY --chmod=755 ${PETALINUX_INSTALLER} .
RUN yes | ./${PETALINUX_INSTALLER} --dir ${PETALINUX_INSTALLATION_DIR}

# Change back to root to install the launcher script
# This has to be done after installing petalinux to not retrigger the
# installer layer in Docker build
USER root
COPY --chmod=755 petalinux_launcher.sh /usr/bin/petalinux_launcher.sh

USER petalinux
WORKDIR /work
RUN rm -rf /tmp/petalinux_installer
ENV petalinux_dir=${PETALINUX_INSTALLATION_DIR}
ENTRYPOINT [ "/usr/bin/petalinux_launcher.sh" ]
