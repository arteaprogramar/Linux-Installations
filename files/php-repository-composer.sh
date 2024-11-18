#!/bin/sh

os_id=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

if [[ $os_id == "debian" || $os_id == "ubuntu" ]]; then
    echo "Estas ejecutando GNU Linux : $os_id"

    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
    HASH=`curl -sS https://composer.github.io/installer.sig`
    echo $HASH
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

else
    echo "Estas ejecutando GNU Linux : $os_id"
fi
