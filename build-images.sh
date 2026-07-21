#!/bin/bash

set -e

# Configuration
BASE_BUILD="${BASE_BUILD:-nvim_test_t1}"
CUSTOM_BUILD="${CUSTOM_BUILD:-nvim_test_t2}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
}

check_files() {
    if [ ! -f "Dockerfile" ]; then
        log_error "Dockerfile not found in current directory"
        exit 1
    fi
    
    if [ ! -f "Dockerfile.nvim" ]; then
        log_error "Dockerfile.nvim not found in current directory"
        exit 1
    fi
    
    if [ ! -d "Config/Basic/nvim" ]; then
        log_error "Config/Basic/nvim directory not found"
        exit 1
    fi
    
    if [ ! -d "Config/Custom1/nvim" ]; then
        log_error "Config/Custom1/nvim directory not found"
        exit 1
    fi
}

build_base_image() {
    log_info "Building base image: ${BASE_BUILD}..."
    docker build -t "${BASE_BUILD}" -f Dockerfile .
    
    if [ $? -eq 0 ]; then
        log_info "Base image built successfully: ${BASE_BUILD}"
    else
        log_error "Failed to build base image"
        exit 1
    fi
}

build_custom_image() {
    log_info "Building custom image: ${CUSTOM_BUILD} from ${BASE_BUILD}..."
    docker build --build-arg BASE_IMAGE="${BASE_BUILD}" -t "${CUSTOM_BUILD}" -f Dockerfile.nvim .
    
    if [ $? -eq 0 ]; then
        log_info "Custom image built successfully: ${CUSTOM_BUILD}"
    else
        log_error "Failed to build custom image"
        exit 1
    fi
}

list_images() {
    log_info "Built images:"
    docker images "${BASE_BUILD}" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    docker images "${CUSTOM_BUILD}" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
}

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --base NAME      Set base image name (default: ubuntu_t1)"
    echo "  --custom NAME    Set custom image name (default: ubuntu_t2)"
    echo "  --skip-base      Skip building base image"
    echo "  --skip-custom    Skip building custom image"
    echo "  --clean          Remove old images before building"
    echo "  --list           List built images"
    echo "  --help           Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  BASE_BUILD       Override base image name"
    echo "  CUSTOM_BUILD     Override custom image name"
    echo ""
    echo "Examples:"
    echo "  $0                              # Build all images with defaults"
    echo "  BASE_BUILD=mybase $0            # Override base image name"
    echo "  $0 --skip-base                  # Build only custom image"
    echo "  $0 --clean                      # Clean and rebuild all"
}

cleanup_images() {
    log_info "Removing existing images..."
    docker rmi "${BASE_BUILD}" 2>/dev/null || true
    docker rmi "${CUSTOM_BUILD}" 2>/dev/null || true
}

# Parse arguments
SKIP_BASE=false
SKIP_CUSTOM=false
CLEAN=false
LIST_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --base)
            BASE_BUILD="$2"
            shift 2
            ;;
        --custom)
            CUSTOM_BUILD="$2"
            shift 2
            ;;
        --skip-base)
            SKIP_BASE=true
            shift
            ;;
        --skip-custom)
            SKIP_CUSTOM=true
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        --list)
            LIST_ONLY=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Main execution
if [ "$LIST_ONLY" = true ]; then
    list_images
    exit 0
fi

check_docker
check_files

if [ "$CLEAN" = true ]; then
    cleanup_images
fi

if [ "$SKIP_BASE" = false ]; then
    build_base_image
fi

if [ "$SKIP_CUSTOM" = false ]; then
    build_custom_image
fi

list_images

log_info "Build complete!"
echo ""
log_info "To run the container with X11 support:"
log_info "  ./docker-run-nvim.sh"
echo ""
log_info "Or manually:"
log_info "  xhost +local:docker"
log_info "  docker run -it --rm -v \${HOME}:\${HOME} -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=\$DISPLAY ${CUSTOM_BUILD}"
