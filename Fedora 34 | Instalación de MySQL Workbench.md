
## Fedora 34 + | Instalación de MySQL Workbench

Documentación
- [MySQL Workbench on Linux (RPM)](https://dev.mysql.com/doc/workbench/en/wb-installing-linux.html#wb-installing-linux-installing-rpm)
- [MySQL Workbench from pkgs.org](https://pkgs.org/search/?q=mysql-workbench)

Requisito
- Acceso Root
- Conexión a Internet


### Instalación de mysql-community.repo

- Descargar, instalar y/o habilitar mysql-tools-community repository

```sh

# Fedora 35
$ sudo dnf install http://repo.mysql.com/mysql80-community-release-fc35.rpm

# Fedora 34
$ sudo dnf install http://repo.mysql.com/mysql80-community-release-fc34.rpm

```

### Instalación de MySQL Workbench

```sh

$ sudo dnf install mysql-workbench-community

```
