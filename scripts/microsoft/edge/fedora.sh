#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'})

# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar Microsoft Edge Estable"
logger "v0.1"
logger "OS : " $osName

# Importar llave
logger "\n\nImportar llave"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 

# Habilitar Microsoft Edge Repository
logger "\n\nHabilitar Microsoft Edge Repository"
sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge.repo

# Instalar Microsoft Edge Stable
logger "\n\nInstalar Microsoft Edge Stable"
sudo dnf -y install microsoft-edge-stable 

# Result
logger "\n\nSe ha instalado correctamente Microsoft Edge"
