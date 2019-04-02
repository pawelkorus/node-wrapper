# node-wrapper

Simple POSIX shell scripts for managing project node version.

## node-wrapper-docker

This script requires `docker` in order to work.

Copy `node-wrapper-docker.sh` to project dir as `npm` and add executable permissions. Then you can work with your project as usuall, i.e.:
```
./npm install
```

By default `node:lts-slim` image is used. You may configure this by creating `.nwdrc` with required version of node, i.e. execute:
```
echo "8-slim" > .nwdrc
```
See [node docker hub page](https://hub.docker.com/_/node/) for possible versions of node containers. You can also use you own images. E.g. if your image name is `my-node` then you can execute following command:
```
echo "my-node:latest" > .nwdrc
```

When copying `node-wrapper-docker.sh` the target name is important. It determines which executable from docker container is used. E.g. if `node-wrapper-docker.sh` is saved in project dir as `npm` then executing `./npm` runs `npm` in a container. Oterwise, if `node-wrapper-docker.sh` is saved as `node` then executing `./node` runs `node` in a container. This way you may run whatever executable is installed in a container. This will also work with symlinks.

All commands in container are executed with current user id and group id.