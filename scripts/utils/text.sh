#!/bin/bash

info(){
    logger $(clear)
    logger "\033[1mArte a Programar\033[0m"
    logger "Script: \033[1m${1}\033[0m"
    logger "OS: " "\033[1m$(getNameOs)\033[0m"
    logger "v${2}\n"
}

logger(){
    echo -e $1 $2 $3
}

loggerBold(){
    echo -e "\033[1m${1}\033[0m"
}

userRootRequired(){
    loggerBold "Se requiere del usuario root para ejecutar el script"
}