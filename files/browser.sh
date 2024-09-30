#!/bin/sh

manager=$1

if "$manager" --version > /dev/null 2>&1; then

    if [ "$manager" == "dnf" ]; then
        sudo dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
        sudo dnf -y install https://packages.microsoft.com/yumrepos/edge/microsoft-edge-stable-129.0.2792.65-1.x86_64.rpm
    fi

    if [ "$manager" == "apt" ]; then
        wget https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_129.0.2792.65-1_amd64.deb  -P temp
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P temp
        sudo apt -y install temp/google-chrome-stable_current_amd64.deb
        sudo apt -y install temp/microsoft-edge-stable_129.0.2792.65-1_amd64.deb
    fi

    if [ "$manager" == "yay" ]; then
        yay -S google-chrome --noconfirm;
        yay -S microsoft-edge-stable-bin --noconfirm
    fi

fi