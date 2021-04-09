## Reconstrucción del paquete RMP de VirtualBox para Fedora 33+

### Descargar el paquete RPM de VirtualBox para Fedora 32

#### Abrir Terminal y movernos a carpeta de Descargar

```
$ cd Download
```

#### Descargar VirtualBox para Fedora 32
```
$ https://download.virtualbox.org/virtualbox/6.1.16/VirtualBox-6.1-6.1.16_140961_fedora32-1.x86_64.rpm
```

#### Instalar paquete para Fedora 32 en Fedora 33 y observar el error
```
$ sudo dnf install VirtualBox-6.1-6.1.16_140961_fedora32-1.x86_64.rpm
```

### Salida de error
```
... 
nothing provides python(abi) = 3.8 needed by VirtualBox-6.1-6.1.16_140961_fedora32-1.x86_64
...
```

### Corregir error con los siguientes pasos

#### Instalar RMPRebuild Package
```
$ sudo dnf install rpmrebuild
```

#### Reconstruir paquete VirtualBox de Fedora 32 para Fedora 33 corrigiendo el error de Python
```
$ sudo rpmrebuild --change-spec-preamble='sed -e "s/6.1.16_140961_fedora32/6.1.16_140961_fedora33/"' --change-spec-requires='sed -e "s/python(abi) = 3.8/python(abi) >= 3.8/"' --package VirtualBox-6.1-6.1.16_140961_fedora32-1.x86_64.rpm
```

#### Instalar dependecias necesarias para VirtualBox
```
$ sudo dnf groupinstall "Development Tools"
$ sudo dnf groupinstall "Development Libraries"
$ sudo dnf install kernel-headers kernel-devel dkms gcc make perl bzip2 binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon
```

#### Instalación de paquete reconstruido de Python
```
$ sudo dnf install ~/rpmbuild/RPMS/x86_64/VirtualBox-6.1-6.1.16_140961_fedora33-1.x86_64.rpm
```

#### Construir modulos del Kernel para Virtual Box
```
$ sudo /usr/lib/virtualbox/vboxdrv.sh setup
```

#### Agregar nuestro usuario al usuario vboxusers que creo VirtualBox
```
$ sudo usermod -a -G vboxusers $username
```
#### Enlace de descarga del paquete que genere
https://drive.google.com/file/d/1CfBbpcATQAKapQfrErTTpxr60tCyWHfp/view?usp=sharing
