# Dev Scripts

Coleção de scripts para configurar rapidamente um ambiente de desenvolvimento: Git, Docker (Engine, Buildx e Compose v2), AWS CLI v2, Terraform, SDKMAN!, NVM, Zsh + Oh My Zsh e pacotes essenciais para sistemas baseados em Ubuntu/Debian. Alguns scripts também suportam macOS.

## Sistemas suportados
- Ubuntu/Debian (com `apt-get`): a maioria dos scripts (linux/ubuntu.sh, docker/docker.sh, docker/docker-compose.sh, git/git.sh, sdkman/sdkman.sh, zsh/zsh.sh).
- Linux genérico (com bash, `curl`/`wget`, `unzip` e `sudo`): terraform/terraform.sh e aws/awscli.sh; docker/docker-compose.sh possui fallback via binário do GitHub.
- macOS: terraform/terraform.sh e aws/awscli.sh (instalação via pkg para AWS CLI); docker/docker-compose.sh tenta instalar o binário do Compose v2 (CLI plugin), mas no macOS normalmente o Docker Desktop já inclui o Compose.

## Estrutura do projeto e o que cada script faz
- linux/ubuntu.sh
  - Atualiza índices do apt e instala pacotes essenciais (curl, wget, ca-certificates, gnupg, lsb-release, build-essential, unzip, zip, locales, etc.).
  - Gera locales comuns e define LANG (padrão `pt_BR.UTF-8`, ajustável pela variável `LOCALE`); seguro para rodar várias vezes.
  - Suporte: Ubuntu/Debian.

- git/git.sh
  - Instala ou atualiza o Git via apt e valida a instalação.
  - Pede interativamente nome e e-mail para `git config --global` e oferece geração de chave SSH (ed25519) com o e-mail informado (ignorada se a chave já existir em `~/.ssh/id_ed25519`).
  - Suporte: Ubuntu/Debian.

- docker/docker.sh
  - Configura o repositório oficial da Docker, instala/atualiza Docker Engine, CLI, containerd, Buildx e o plugin Compose v2.
  - Habilita/ajusta o serviço (systemd), cria o grupo `docker` e adiciona o usuário atual ao grupo.
  - Suporte: Ubuntu (baseado em apt). Requer `sudo`.

- docker/docker-compose.sh
  - Instala/atualiza o Docker Compose v2.
  - Caminho 1 (Ubuntu/Debian): detecta a distribuição via `/etc/os-release` e usa apt com o repositório oficial da Docker correspondente (ubuntu ou debian).
  - Caminho 2 (sem apt): baixa a última versão do GitHub Releases e instala como CLI plugin em `/usr/local/lib/docker/cli-plugins` (cria um shim `docker-compose` se necessário).
  - Suporte: Ubuntu/Debian (apt) e fallback para Linux/macOS via binário.

- aws/awscli.sh
  - Instala/atualiza o AWS CLI v2 mais recente (detecta SO e arquitetura), usando URLs oficiais da AWS.
  - Linux: exige `unzip`; instala em `/usr/local/bin` e `/usr/local/aws-cli` (pode ser ajustado por variáveis de ambiente). macOS: instala via `.pkg`.
  - Idempotente (`--update`). Mostra versão ao final.
  - Suporte: Linux e macOS.

- terraform/terraform.sh
  - Instala/atualiza o Terraform (detecta SO/arquitetura) e valida checksum SHA256.
  - Define a versão via variável `TERRAFORM_VERSION` (ex.: `1.9.5`); se não definida, busca a mais recente via API da HashiCorp.
  - Instala em `/usr/local/bin` por padrão (ajustável via `INSTALL_DIR`).
  - Suporte: Linux e macOS. Requer `unzip` e `curl` ou `wget`.

- sdkman/sdkman.sh
  - Instala dependências (curl, unzip, zip) via apt e executa a instalação do SDKMAN!.
  - Idempotente: se `~/.sdkman` já existir, a instalação é ignorada.
  - Ao final, carrega o SDKMAN e imprime a versão (`sdk version`).
  - Suporte: Ubuntu/Debian.

- nvm/nvm.sh
  - Instala a dependência (curl) via apt e busca a versão mais recente do NVM na API do GitHub.
  - Cria o diretório base em `$NVM_DIR` (`~/.nvm` por padrão) e executa o instalador oficial do NVM.
  - Ao final, carrega o NVM e imprime a versão (`nvm --version`).
  - Suporte: Ubuntu/Debian.

- zsh/zsh.sh
  - Instala/atualiza o Zsh (e curl/git) via apt e define o Zsh como shell padrão do usuário (`chsh`).
  - Instala o Oh My Zsh via instalador oficial, sem executar o Zsh ao final e sem sobrescrever um `~/.zshrc` existente.
  - Idempotente: se `~/.oh-my-zsh` já existir, a instalação é ignorada.
  - Suporte: Ubuntu/Debian.

## Pré-requisitos gerais
- bash, conexão com a internet.
- Permissão de superusuário (`sudo`) para operações de instalação no sistema.
- Para scripts baseados em apt: um sistema Ubuntu/Debian com `apt-get`.
- Para Terraform e AWS CLI no Linux: `unzip` instalado (o `linux/ubuntu.sh` já o instala; os scripts abortam com uma mensagem se estiver ausente).
- `curl` ou `wget` (os scripts tentam usar um dos dois quando necessário).

## Como executar
1. Clone este repositório e entre na pasta:
   - git clone https://github.com/sandrogiacom/dev-scripts.git
   - cd dev-scripts
2. Execute o(s) script(s) desejado(s). Você pode torná-los executáveis ou chamar com `bash`:

Exemplos (Ubuntu/Debian):
- sudo bash linux/ubuntu.sh
- sudo bash docker/docker.sh
- sudo bash docker/docker-compose.sh
- bash git/git.sh   # interativo: nome/e-mail e SSH key
- bash sdkman/sdkman.sh
- bash nvm/nvm.sh
- bash zsh/zsh.sh

Exemplos (Linux/macOS):
- sudo bash aws/awscli.sh
- TERRAFORM_VERSION=1.9.5 sudo bash terraform/terraform.sh   # ou sem a variável para instalar a última versão

## Observações importantes
- Docker: após ser adicionado ao grupo `docker`, encerre a sessão e entre novamente (ou rode `newgrp docker`) para que a mudança tenha efeito.
- Zsh: após a instalação, abra um novo terminal (ou rode `source ~/.zshrc`) para carregar o Oh My Zsh.
- Alguns scripts adicionam repositórios e chaves GPG oficiais (ex.: Docker) e podem alterar arquivos em `/etc/apt`.
- Os scripts são pensados para serem idempotentes quando possível; rodar novamente deve manter o ambiente atualizado.
- No macOS, você poderá ser solicitado a informar a senha de administrador para concluir a instalação.
