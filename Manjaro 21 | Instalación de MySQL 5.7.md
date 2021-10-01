## Instalación de MySQL 5.7 en Manjaro o ArchLinux

El objetivo de esta publicación es ayudarte a instalar MySQL 5.7 siguiendo la documentación oficial de MySQL Dev.

#### Requisitos

- Acceso administrativo
- Conocimientos básicos en el uso de la terminal
- Tener instalado YAY (AUR Helper)

#### Material 

- Documentación: **Installing MySQL on Unix/Linux Using Generic Binaries** [https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html]
- Descargar: **MySQL binary distribution** [https://downloads.mysql.com/archives/community/]

### Paquetes necesarios en Manjaro y/o ArchLinux

Antes o durante la instalación de MySQL es necesario instalar los siguientes paquetes en tu distribución

```
$ sudo pacman -S libaio
$ sudo pacman -S numactl
$ sudo yay -S ncurses5-compat-libs
```

### Importante

Recuerda guardar **TU CONTRASEÑA TEMPORAL**
