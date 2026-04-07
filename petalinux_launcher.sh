#!/bin/bash
set -a
source $petalinux_dir/settings.sh $petalinux_dir
set +a
exec "$1"
