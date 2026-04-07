#!/bin/bash

PUID=$(id -u)
PGID=$(id -g)

docker build --build-arg PUID=$PUID --build-arg PGID=$PGID -t mw_petalinux_install:2022.2 .
#docker build --build-arg PUID=$PUID --build-arg PGID=$PGID --target mw_petalinux_base -t mw_petalinux_base:2022.2 .
