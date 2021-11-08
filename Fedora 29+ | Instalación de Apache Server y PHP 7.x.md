## Fedora 29+ | Instalación de Apache Server y PHP 7.x

El objetivo de las instrucciones es mostrar como se realiza la instalación del servidor Apache & PHP 7.3 en Fedora 28 o superior.

### Requisitos
Instalación de "REMI Repository"

##### Add Remi repository to Fedora 35:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-35.rpm
```

##### Add Remi repository to Fedora 34:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-34.rpm
```

##### Add Remi repository to Fedora 33:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-33.rpm
```

##### Add Remi repository to Fedora 32:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-32.rpm
```

##### Add Remi repository to Fedora 31:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-31.rpm
```

##### Add Remi repository to Fedora 30:
```
➡ dnf -y install http://rpms.remirepo.net/fedora/remi-release-30.rpm
```

##### Add Remi repository to Fedora 29:
```
➡ dnf install -y  http://rpms.remirepo.net/fedora/remi-release-29.rpm
```

#### Instalación de DNF Pluggin si no esta instalado
```
➡ dnf -y install dnf-plugins-core
```

#### Habilitar REMI Repo 
```
➡ dnf config-manager --set-enabled remi
```

#### Instalar PHP 7.3 
```
➡ dnf --enablerepo=remi install php73 httpd php73-php-common
```

#### Instalación de las extensiones de PHP 7.3 
```
➡ dnf --enablerepo=remi install php73-php-intl php73-php-cli php73-php-fpm php73-php-mysqlnd php73-php-zip php73-php-devel php73-php-gd php73-php-mcrypt php73-php-mbstring php73-php-curl php73-php-xml php73-php-pear php73-php-bcmath php73-php-json
```

#### Instalación de PHP Composer
```
➡ dnf install php php-composer-installers
```

#### Comprobar instalación de PHP
```
➡ php73 -v
```

#### Comenzar Apache Service 
```
➡ systemctl start httpd.service
```

#### Configurar del Firewall
```
➡ firewall-cmd --get-active-zones
➡ firewall-cmd --permanent --zone=public --add-service=http
➡ systemctl restart firewalld.service
➡ systemctl reload firewalld
```
