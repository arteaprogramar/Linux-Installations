#!/bin/bash

getNameOs(){
    osName=$(((egrep '^(NAME)=' /etc/os-release) | awk -F = {'print $2'}) | tr -d \")
    echo $osName
}

getIdOs(){
    id=$(((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'}) | tr -d \")
    echo $id
}

getVersionOs(){
    {
        version=$(rpm -E %"$(getIdOs)")
    } || {
        version=-1
    }

    echo $version
} 

getUser(){
    echo -e $(whoami)
}