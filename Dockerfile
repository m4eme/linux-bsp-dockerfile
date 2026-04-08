ARG UBUNTU_RELEASE=focal-20220531
FROM ubuntu:${UBUNTU_RELEASE} AS mw_petalinux
ARG PUID=1000
ARG PGID=1000

RUN dpkg --add-architecture i386
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
autoconf \
automake \
bc \
bison \
build-essential \
chrpath \
cpio \
debianutils \
diffstat \
flex \
gawk \
gcc \
gcc-multilib \
git \
gnupg \
gzip \
iproute2 \
iputils-ping \
libegl1-mesa \
libncurses-dev \
libncurses5-dev \
libsdl1.2-dev \
libssl-dev \
libtinfo5 \
libtool \
locales \
locales-all \
lsb-release \
make \
net-tools \
pax \
pylint3 \
python3 \
python3-git \
python3-jinja2 \
python3-pexpect \
python3-pip \
rsync \
screen \
socat \
texinfo \
tftpd-hpa \
unzip \
vim \
xterm \
xz-utils \
zlib1g-dev \
zlib1g:i386

# set proper locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8


RUN useradd -ms /bin/bash petalinux

# not really necessary, just to make it easier to install packages on the run...
RUN echo "root:peta" | chpasswd

ARG PETALINUX_RELEASE=2022.2
ARG PETALINUX_INSTALLATION_DIR=/opt/Xilinx/petalinux/${PETALINUX_RELEASE}

RUN mkdir -p ${PETALINUX_INSTALLATION_DIR}
RUN chown $PUID:$PGID ${PETALINUX_INSTALLATION_DIR}
RUN mkdir /tmp/petalinux_installer
RUN chown petalinux /tmp/petalinux_installer

# Cannot be root to install petalinux
USER petalinux
ARG PETALINUX_INSTALLER=petalinux-v2022.2-10141622-installer.run
WORKDIR /tmp/petalinux_installer
COPY --chmod=755 ${PETALINUX_INSTALLER} .
RUN yes | ./${PETALINUX_INSTALLER} --dir ${PETALINUX_INSTALLATION_DIR}

# Change back to root to install the launcher script
# This has to be done after installing petalinux to not retrigger the
# installer layer in Docker build
USER root
COPY --chmod=755 petalinux_launcher.sh /usr/bin/petalinux_launcher.sh
VOLUME /work
VOLUME /opt/yocto

WORKDIR /work
RUN rm -rf /tmp/petalinux_installer

#RUN groupmod -g $PGID petalinux
#RUN usermod -u $PUID -g $PGID petalinux
#RUN chown -R petalinux:petalinux ${PETALINUX_INSTALLATION_DIR}

# set bash as default shell
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

USER petalinux
ENV petalinux_dir=${PETALINUX_INSTALLATION_DIR}
ENTRYPOINT [ "/usr/bin/petalinux_launcher.sh" ]
