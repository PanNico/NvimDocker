#!/bin/bash
# docker-run-nvim.sh

# docker build -t ubuntu_nvim -f Dockerfile .

echo "Configuring X11 access for Docker containers..."
xhost +local:docker

docker run -it --rm \
  --dns 8.8.8.8 --dns 8.8.4.4 \
  -v "${HOME}:${HOME}" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=$DISPLAY \
  nvim_test_t2 

xhost -local:docker
