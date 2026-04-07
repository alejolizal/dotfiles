# =============================================================================
# Imagen base para desarrollo SII
# Replica exactamente el entorno del host: Neovim + LazyVim, Zsh + P10k,
# Java 17/21/11, Node 25, Maven 3.8.7, CLI tools
# =============================================================================
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG DEBIAN_FRONTEND=noninteractive

# =============================================================================
# Capa 1: Paquetes del sistema
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build essentials
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    fontconfig \
    # Python (para pre-commit)
    python3 \
    python3-pip \
    python3-venv \
    # Shell
    zsh \
    # Utilidades
    tree \
    tidy \
    ca-certificates \
    libssl-dev \
    gnupg \
    software-properties-common \
    # Dependencias de sistema para Playwright
    libglib2.0-0t64 \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0t64 \
    libcups2t64 \
    libdrm2 \
    libxkbcommon0 \
    libatspi2.0-0t64 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2t64 \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# Capa 2: CLI tools con versiones exactas
# =============================================================================

# ripgrep 14.1.0
RUN curl -fsSL https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb -o /tmp/rg.deb \
    && dpkg -i /tmp/rg.deb && rm /tmp/rg.deb

# fd 9.0.0
RUN curl -fsSL https://github.com/sharkdp/fd/releases/download/v9.0.0/fd_9.0.0_amd64.deb -o /tmp/fd.deb \
    && dpkg -i /tmp/fd.deb && rm /tmp/fd.deb

# fzf 0.44.1
RUN curl -fsSL https://github.com/junegunn/fzf/releases/download/0.44.1/fzf-0.44.1-linux_amd64.tar.gz | tar -xz -C /usr/local/bin/

# lazygit 0.44.1 (versión estable compatible)
RUN LAZYGIT_VERSION=0.44.1 \
    && curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar -xz -C /usr/local/bin/ lazygit

# lazydocker 0.24.1 (versión estable)
RUN LAZYDOCKER_VERSION=0.24.1 \
    && curl -fsSL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" | tar -xz -C /usr/local/bin/ lazydocker

# jq 1.7 (apt en Ubuntu 24.04 trae 1.7)
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

# httpie
RUN pip3 install --break-system-packages httpie==3.2.2

# =============================================================================
# Capa 3: Node.js via NVM
# =============================================================================
USER vscode
ENV NVM_DIR=/home/vscode/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install 25.1.0 \
    && nvm alias default 25.1.0 \
    && nvm use default \
    && npm install -g @commitlint/cli @commitlint/config-conventional

# =============================================================================
# Capa 4: Java via SDKMAN
# =============================================================================
ENV SDKMAN_DIR=/home/vscode/.sdkman
RUN curl -s "https://get.sdkman.io" | bash \
    && bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh \
    && sdk install java 21.0.9-tem \
    && sdk install java 17.0.17-tem \
    && sdk install java 11.0.25-tem \
    && sdk default java 17.0.17-tem \
    && sdk install maven 3.8.7"

# =============================================================================
# Capa 5: Neovim
# =============================================================================
USER root
RUN curl -fsSL https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz | tar -xz -C /opt/ \
    && ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Copiar configuración de Neovim
COPY --chown=vscode:vscode nvim-config/ /home/vscode/.config/nvim/

# Pre-clonar lazy.nvim para primer arranque más rápido
USER vscode
RUN git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git \
    /home/vscode/.local/share/nvim/lazy/lazy.nvim

# =============================================================================
# Capa 6: Zsh + Oh My Zsh + Plugins
# =============================================================================
# Oh My Zsh ya viene instalado en la imagen base de Microsoft
# Solo instalar tema y plugins custom
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
       /home/vscode/.oh-my-zsh/custom/themes/powerlevel10k \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
       /home/vscode/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions.git \
       /home/vscode/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
       /home/vscode/.oh-my-zsh/custom/plugins/fast-syntax-highlighting \
    && git clone https://github.com/marlonrichert/zsh-autocomplete.git \
       /home/vscode/.oh-my-zsh/custom/plugins/zsh-autocomplete

# Copiar configuración de Zsh
COPY --chown=vscode:vscode zsh-config/.zshrc /home/vscode/.zshrc
COPY --chown=vscode:vscode zsh-config/.p10k.zsh /home/vscode/.p10k.zsh
COPY --chown=vscode:vscode zsh-config/.zsh_aliases /home/vscode/.zsh_aliases

# =============================================================================
# Capa 7: Claude Code CLI
# =============================================================================
RUN . "$NVM_DIR/nvm.sh" && npm install -g @anthropic-ai/claude-code

# =============================================================================
# Capa 8: pre-commit
# =============================================================================
USER root
RUN pip3 install --break-system-packages pre-commit

# =============================================================================
# Capa 9: Configuración final
# =============================================================================

# Shell por defecto: zsh
RUN chsh -s /usr/bin/zsh vscode

# Variables de entorno
ENV EDITOR=nvim
ENV SHELL=/usr/bin/zsh
ENV LANG=en_US.UTF-8

# Permisos finales
RUN chown -R vscode:vscode /home/vscode/

USER vscode
WORKDIR /workspace

CMD ["zsh"]
