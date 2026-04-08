#!/bin/bash
set -a
SHELL="/bin/bash"
source $petalinux_dir/settings.sh $petalinux_dir
set +a
exec "$@"
