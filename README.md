# linux-bsp-dockerfile
Dockerfiles for various Linux-based BSP building environments
- Petalinux 
- Enclustra BSP build environment (buildroot based)
  https://github.com/enclustra-bsp/bsp-xilinx

This repository contains a flexible Dockerfile and a build script to build ephemeral containers for using Petalinux and Yocto for Xilinx targets.

## Petalinux installers
There are no public download links for Petalinux. The path to the desired Petalinux installer is passed as an build argument to the Dockerfile.

## Build script
The build script imports the following environment variables. Otherwise it defaults to 2022.2 and a default installer name.

* PETALINUX_RELEASE: e.g. 2022.2
* PETALINUX_INSTALLER: e.g. petalinux-v2022.2-10141622-installer.run
>>>>>>> b43fa2a (Created single Dockerfile for all releases. Use build.sh script)
