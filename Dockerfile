FROM ubuntu:24.04

# Reduce output
ENV DEBIAN_FRONTEND=noninteractive

# Central variable for local installations
ENV INSTALL_PREFIX="/usr/local"
ENV GOROOT="/opt/go"
ENV GOPATH="/root/go"

# Library paths (includes standard system and multiarch directories)
ENV LD_LIBRARY_PATH="${INSTALL_PREFIX}/lib:/usr/lib:/lib:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu"
ENV PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig:${INSTALL_PREFIX}/share/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig"

# Binary paths
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${INSTALL_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR /root

# System packages
RUN apt update && apt install -y \
    build-essential cmake python3 git pkg-config wget curl clang \
    fzf lua5.1 luarocks libuv1-dev lua-luv-dev lua-lpeg-dev \
    libunibilium-dev libluajit-5.1-dev lua-bitop-dev \
    silversearcher-ag ripgrep fd-find \
    && rm -rf /var/lib/apt/lists/*

# Install Go
RUN mkdir -p /opt/go && cd /tmp && \
    wget https://go.dev/dl/go1.25.1.linux-amd64.tar.gz && \
    tar -C /opt -xzf go1.25.1.linux-amd64.tar.gz && \
    rm go1.25.1.linux-amd64.tar.gz

# Tree-sitter
RUN git clone --depth 1 --branch v0.25.9 https://github.com/tree-sitter/tree-sitter.git \
    && cd tree-sitter && PREFIX=${INSTALL_PREFIX} make install -j$(nproc) \
    && cd .. && rm -rf tree-sitter

# Lazygit
RUN git clone --depth 1 --branch v0.55.0 https://github.com/jesseduffield/lazygit.git \
    && cd lazygit && GOBIN=${INSTALL_PREFIX}/bin CGO_ENABLED=0 GOOS=linux go install \
    && cd .. && rm -rf lazygit

# UTF8proc
RUN git clone --depth 1 https://github.com/JuliaStrings/utf8proc.git \
    && cd utf8proc \
    && cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
    && cmake --build build -j$(nproc) && cmake --install build \
    && cd .. && rm -rf utf8proc

# Neovim
RUN git clone --depth 1 --branch v0.11.4 https://github.com/neovim/neovim.git \
    && cd neovim \
    && cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX} \
    && cmake --build build -j$(nproc) && cmake --install build \
    && cd .. && rm -rf neovim

# Initial Neovim configuration with lazy.nvim setup
COPY Config/Basic/nvim /root/.config/nvim

# Sync plugins
RUN ${INSTALL_PREFIX}/bin/nvim --headless +Lazy! sync +qa || true

CMD ["/bin/bash"]
