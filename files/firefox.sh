#!/bin/sh

os_id=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

if [[ $os_id = "debian" || $os_id = "ubuntu" ]]; then

    if [ $os_id = "debian" ]; then
        sudo apt -y install firefox-esr
    fi

    if [ $os_id = "ubuntu" ]; then

        sudo install -d -m 0755 /etc/apt/keyrings
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
        gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
        echo '
        Package: *
        Pin: origin packages.mozilla.org
        Pin-Priority: 1000
        ' | sudo tee /etc/apt/preferences.d/mozilla

        sudo apt update && sudo apt -y remove firefox
        sudo apt update && sudo apt -y install firefox

    fi

else
    echo "Se requiere Ubuntu o Debian pero estas ejecutando : $os_id"
fi