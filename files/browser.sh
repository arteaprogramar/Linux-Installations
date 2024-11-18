#!/bin/sh

manager=$1

if "$manager" --version > /dev/null 2>&1; then

    if [ "$manager" = "dnf" ]; then
        sudo dnf -y install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

        # Instalación de Microsoft Edge
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        sudo dnf config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
        sudo mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge.repo
        sudo dnf install microsoft-edge-stable
    fi

    if [ "$manager" = "apt" ]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P temp
        sudo dpkg -i temp/google-chrome-stable_current_amd64.deb
        sudo apt -f install -y

         # Instalación de Microsoft Edge
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
        sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'
        sudo rm microsoft.gpg
        sudo apt update
        sudo apt install microsoft-edge-stable
    fi

    if [ "$manager" = "yay" ]; then
        yay -S google-chrome --noconfirm;
        yay -S microsoft-edge-stable-bin --noconfirm
    fi

fi