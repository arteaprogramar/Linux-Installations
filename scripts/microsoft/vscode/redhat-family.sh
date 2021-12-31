#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'})

# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar Visual Code en RHEL Family (Fedora, CentOS, etc)"
logger "v0.1"
logger "OS : " $osName

# Importar llave
logger "\n\nImportar llave"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Habilitar VSCode Repository
logger "\n\nHabilitar VSCode Repository"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Instalar VS Code
logger "\n\nInstalar VSCode"
sudo dnf -y install code

# Result
logger "\n\nSe ha instalado correctamente VSCode"
