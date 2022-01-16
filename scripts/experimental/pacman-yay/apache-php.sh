#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Menú de Instalación de Apache Server y PHP (Repositorios Oficiales o AUR)" "1.1"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Documentacion
documentation "Wiki Arch" "https://wiki.archlinux.org/title/PHP"

# Menú de instalación
loggerBold "Menú de Instalación de Apache Server y PHP"
logger "Ingrese 0 para salir"
logger "Ingrese 1 para Instalar PHP desde Repositorios Oficiales"
logger "Ingrese 2 para Instalar PHP desde ArchLinux User Repository"
item=""

while [[ ! $item =~ ^[0-2]{1} ]]; do
    read -p "¿Que accion desea realizar? (0|1|2) : " item

    if [[ ! $item =~ ^[0-2]{1} ]]; then
    
        item=""
    
    elif [ $item == "1" ]; then
    
        sh $(dirname "$0")/apache-php-official.sh
    
    elif [ $item == "2" ]; then
        
        {
            yay --version
        } || {
            loggerBold "Este script requiere YAY Helper"
            exit
        }

        sh $(dirname "$0")/apache-php-aur.sh
    else
        exit
    fi

done