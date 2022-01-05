#!/bin/bash

source $(dirname "$0")/../utils/text.sh
source $(dirname "$0")/../utils/file.sh
source $(dirname "$0")/../utils/os.sh

info "Instalación de Microsoft Visual Code" "1.0"

# Importar llave
loggerBold "\n\nImportar llave"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Habilitar VSCode Repository
loggerBold "\n\nHabilitar VSCode Repository"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Instalar VS Code
loggerBold "\n\nInstalar VSCode"
sudo dnf -y install code

# Result
loggerBold "\n\nSe ha instalado correctamente VSCode"
