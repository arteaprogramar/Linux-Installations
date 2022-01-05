#!/bin/bash

source $(dirname "$0")/../utils/text.sh
source $(dirname "$0")/../utils/file.sh
source $(dirname "$0")/../utils/os.sh

info "Instalación de Microsoft Edge" "1.0"

# Importar llave
loggerBold "\n\nImportar llave"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 

# Habilitar Microsoft Edge Repository
loggerBold "\n\nHabilitar Microsoft Edge Repository"
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge.repo

# Instalar Microsoft Edge Stable
loggerBold "\n\nInstalar Microsoft Edge Stable"
sudo dnf -y install microsoft-edge-stable 

# Result
loggerBold "\n\nSe ha instalado correctamente Microsoft Edge"
