## RedHat Family 8+ | Instalación de VirtualBox 

#### Ingresar en modo superusuario
```
$ su
```

#### Descargar y mover a la ruta `/etc/yum.repos.d/` el repositorio de `virtualbox.repo`
$ wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d/

#### Instalar dependecias necesarias para VirtualBox
```
$ yum groupinstall "Development Tools"
$ yum groupinstall "Development Libraries"
$ yum install kernel-headers kernel-devel dkms gcc make perl bzip2 binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon
```

#### Instalación VirtualBox
```
$ yum install VirtualBox-6.1
```

#### Construir modulos del Kernel para Virtual Box
```
$ /usr/lib/virtualbox/vboxdrv.sh setup
```

#### Agregar nuestro usuario al usuario vboxusers que creo VirtualBox
```
$ sudo usermod -a -G vboxusers $username
```
#### Virtualbox ha sido instalado
