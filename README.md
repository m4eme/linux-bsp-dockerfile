# linux-bsp-dockerfile
Dockerfiles for various Linux-based BSP building environments
- Petalinux 
- Enclustra BSP build environment (buildroot based)
  https://github.com/enclustra-bsp/bsp-xilinx

This repository contains a flexible Dockerfile and a build script to build ephemeral containers for using Petalinux and Yocto for Xilinx targets.

## Petalinux installers
There are no public download links for Petalinux. The path to the desired Petalinux installer is passed as an build argument to the Dockerfile.

## Build
The recommended way to build the image is to use docker compose. Copy the the env-example file as .env and modify the variables as needed. 

* PETALINUX_RELEASE: e.g. 2022.2
* PETALINUX_INSTALLER: path to the Petalinux installer e.g. petalinux-v2022.2-10141622-installer.run
* UBUNTU_RELEASE: .e.g. "focal-20200729" exact image digest for the desired Ubuntu base image. Use this to prevent Docker from pulling versions outside the compatibility list. For example, pulling ubuntu:20.04 will pull 20.04.5 which is not in the list for Petalinux 2022.2

* UID: uid of the desired petalinux user. The user must have access to the working folder
* GID: group id of the desired group for the container user. The user must have access to the working folder
* RUNNER_UID: uid of the gitlab-runner user.
* RUNNER_GID: group id of the gitlab-runner group.

### Build targets
Use docker compose: 
```docker compose build <desired build target>```

#### petalinux-base
Pulls the Ubuntu image, creates the petalinux user, installs the desired petalinux version and adds the launcher script.

#### petalinux-runner
Currently identical to petalinux-base but with the runner tag. This target could be modified for CI runners if needed.

### Run targets

#### petalinux
Extends petalinux-base mounting the current working directory as /work

#### petalinux-cache
Bind-mounts /opt/yocto with the same path to be used as shared sstate cache or mirror.

#### petalinux-runner
Extends petalinux-base and passes the RUNNER_UID and RUNNER_GID variables as UID and GID for the container. 

## Running petalinux
### Docker compose

Export UID and GID:
```
export UID
export GID=$(id -g)

```

Once in the petalinux project directory on a symlink-free path, run a petalinux command:
```docker -f <symlink-free path to compose.yaml> run <desired build target> <petalinux command>```
For example: ```docker -f work/linux-bsp-dockerfile/compose.yaml run petalinux-config -c rootfs ```

### Docker run
Use readlink -f to obtain the canonical directory name of your petalinux project
```docker run --rm -v $(readlink -f <path to project>):/work -v /opt/yocto:/opt/yocto -it mw_petalinux:<petalinux version> <petalinux command>```
For example ```docker run --rm -v $(readlink -f /work/project):/work -v /opt/yocto:/opt/yocto -it mw_petalinux:2022.2 petalinux-config```
