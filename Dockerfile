FROM ubuntu:24.04

WORKDIR /root

RUN apt update

# Basic env
RUN apt install -y \
    build-essential \
    cmake \
    python3 \
    git \
    pkg-config \
    wget \
    curl \
    clang 

# Nvim needs
RUN apt install -y \
    fzf \
    lua5.1 \
    luarocks \
    libuv1-dev \
    lua-luv-dev \
    lua-lpeg-dev \
    libunibilium-dev \
    libluajit-5.1-dev \
    lua-bitop-dev \
    silversearcher-ag \
    ripgrep \
    fd-find

RUN mkdir go; cd go; \
    wget https://go.dev/dl/go1.25.1.linux-amd64.tar.gz
RUN cd go; tar -xvf go1.25.1.linux-amd64.tar.gz
RUN mv go/go /opt

RUN git clone https://github.com/tree-sitter/tree-sitter.git
RUN cd tree-sitter; git checkout v0.25.9; \
    PREFIX=/usr/local make -j6; make install

RUN git clone https://github.com/jesseduffield/lazygit.git
RUN cd lazygit; git checkout v0.55.0; \
    export GOROOT="/opt/go"; \
    export PATH="$GOROOT/bin:$PATH"; \
    GOPATH=/usr/local/bin CGO_ENABLED=0 GOOS=linux go install

RUN git clone https://github.com/sysfce2/libutf8proc.git
RUN cd libutf8proc; git checkout 72918b954b4a85c00106842b073a4e5178209f95; \
    mkdir build; cd build; \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local ..; make -j6; make install

RUN git clone https://github.com/neovim/neovim.git
RUN cd neovim; git checkout v0.11.4; \
    mkdir build; cd build; \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/local ..; make -j6; make install

RUN echo "export LD_LIBRARY_PATH=\"/usr/local/lib:$LD_LIBRARY_PATH\"" >> /root/.bashrc
RUN echo "export GOROOT=\"/opt/go\"" >> /root/.bashrc
RUN echo "export PATH=\"$GOROOT/bin:$PATH\"" >> /root/.bashrc

COPY Config/Basic/nvim /root/.config/nvim
RUN LD_LIBRARY_PATH="/usr/local/lib::$LD_LIBRARY_PATH" \
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

