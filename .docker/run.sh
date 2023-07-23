#!/bin/bash
IMAGE="uois/uois-cuda:latest"
ROOT_DIR="/home/kuldeep/phd/code/grasp_generation/uois/"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--root-dir)
            ROOT_DIR="$2"
            shift
            shift
        ;;
        *)
            echo "Unknown option: $1"
            exit 1
        ;;
    esac
done

# Convert relative path to absolute path
ROOT_DIR="$(realpath "$ROOT_DIR")"

# Run docker container with additional volume
docker run  \
--interactive --tty --rm \
--network host \
--ipc host \
--privileged \
--security-opt seccomp=unconfined \
-v /tmp/.docker.xauth:/tmp/.docker.xauth \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ${ROOT_DIR}:/root/uois \
-e XAUTHORITY=/tmp/.docker.xauth \
-e QT_X11_NO_MITSHM=1 \
-e DISPLAY=:1 \
--gpus all \
--volume /etc/localtime:/etc/localtime:ro \
/bin/bash