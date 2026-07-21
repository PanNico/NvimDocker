#!/bin/bash
# docker-run-nvim.sh
# Run NvimDocker container permanently (without --rm)

set -e

CONTAINER_NAME="${CONTAINER_NAME:-nvim_dev}"
CUSTOM_BUILD="${CUSTOM_BUILD:-nvim_work1}"

# Check if container exists and is running
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} is already running. Reconnecting..."
    docker exec -it "${CONTAINER_NAME}" bash
    exit 0
fi

# Check if container exists but stopped
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container ${CONTAINER_NAME} exists but stopped. Starting..."
    docker start "${CONTAINER_NAME}"
    docker exec -it "${CONTAINER_NAME}" bash
    exit 0
fi

# Allow Docker to access X11 display
xhost +local:docker 2>/dev/null || true

# Start new permanent container
echo "Starting permanent container: ${CONTAINER_NAME}"
docker run -d --name "${CONTAINER_NAME}" \
    -v "${HOME}:${HOME}" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY="${DISPLAY}" \
    -e XAUTHORITY="${XAUTHORITY:-${HOME}/.Xauthority}" \
    -v "${XAUTHORITY:-${HOME}/.Xauthority}:${XAUTHORITY:-${HOME}/.Xauthority}:ro" \
    -w "${HOME}" \
    "${CUSTOM_BUILD}" \
    tail -f /dev/null  # Keep container running

sleep 1  # Give container time to start

# Attach to it
docker exec -it "${CONTAINER_NAME}" bash
