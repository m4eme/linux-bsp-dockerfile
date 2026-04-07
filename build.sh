#!/bin/bash

PUID=$(id -u)
PGID=$(id -g)

set -a
source .env
set +a

echo $PETALINUX_RELEASE

docker build \
  --build-arg PUID=$PUID \
  --build-arg PGID=$PGID \
  --build-arg PETALINUX_RELEASE=$PETALINUX_RELEASE \
  --build-arg PETALINUX_INSTALLER=$PETALINUX_INSTALLER \
  --build-arg UBUNTU_RELEASE=$UBUNTU_RELEASE \
  -t mw_petalinux_install:$PETALINUX_RELEASE .
#docker build --build-arg PUID=$PUID --build-arg PGID=$PGID --target mw_petalinux_base -t mw_petalinux_base:2022.2 .
