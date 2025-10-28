# Usando imagem base do Ruby 2.7.8
FROM ruby:2.7.8

# Argumentos
ARG NODE_VERSION=14
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Evitar prompts durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências do sistema
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  # Dependências essenciais
  build-essential \
  git \
  curl \
  wget \
  gnupg2 \
  ca-certificates \
  lsb-release \
  apt-transport-https \
  # PostgreSQL client
  postgresql-client \
  libpq-dev \
  # Para wkhtmltopdf (PDF generation)
  xfonts-base \
  xfonts-75dpi \
  fontconfig \
  libjpeg62-turbo \
  libxrender1 \
  xvfb \
  # Utilitários para descompressão
  xz-utils \
  # Outras dependências
  imagemagick \
  libmagickwand-dev \
  zlib1g-dev \
  liblzma-dev \
  libxml2-dev \
  libxslt1-dev \
  libreadline-dev \
  redis-tools \
  # Ferramentas úteis
  vim \
  nano \
  less \
  htop \
  tree \
  jq \
  zsh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/*

# Instalar Node.js (binário) e Yarn
# Define versão completa do Node 14 para garantir URL estável
ARG NODE_DIST_VERSION=14.21.3
RUN set -eux; \
  curl -fsSL https://nodejs.org/dist/v$NODE_DIST_VERSION/node-v$NODE_DIST_VERSION-linux-x64.tar.xz -o /tmp/node.tar.xz; \
  tar -xJf /tmp/node.tar.xz -C /usr/local --strip-components=1; \
  rm /tmp/node.tar.xz; \
  ln -sf /usr/local/bin/node /usr/bin/node; \
  ln -sf /usr/local/bin/npm /usr/bin/npm; \
  ln -sf /usr/local/bin/npx /usr/bin/npx; \
  npm install -g yarn

# Instalar wkhtmltopdf (para PDF generation)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb \
  && dpkg -i wkhtmltox_0.12.6-1.buster_amd64.deb || true \
  && apt-get install -f -y \
  && rm wkhtmltox_0.12.6-1.buster_amd64.deb

# Criar usuário não-root
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh \
  # Adicionar sudo support
  && apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*


# Instalar Oh My Zsh para o usuário vscode
USER $USERNAME
RUN git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh \
  && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
  && sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc \
  && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc \
  && echo 'export RAILS_ENV=development' >> ~/.zshrc \
  && echo 'export RACK_ENV=development' >> ~/.zshrc

# Voltar para root para configurações finais
USER root

# Definir shell padrão
ENV SHELL=/bin/zsh

# Configurar diretório de trabalho
WORKDIR /workspaces/todo-ajax-datatable

# Instalar bundler versão específica (alinha com Gemfile.lock)
RUN gem install bundler -v 2.3.27 \
  && gem install foreman -N

# Configurar gems para serem instaladas no volume
ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_PATH=$GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH
ENV BUNDLE_BIN=/usr/local/bundle/bin
ENV PATH=$BUNDLE_BIN:$PATH

# Garantir permissões corretas
RUN mkdir -p $GEM_HOME && chown -R $USERNAME:$USERNAME $GEM_HOME

# Voltar para usuário vscode
USER $USERNAME

# Limpar
ENV DEBIAN_FRONTEND=dialog

# Manter container rodando
CMD ["/bin/zsh"]
