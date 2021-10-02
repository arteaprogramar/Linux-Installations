## Instalación de PostgreSQL 1x y PGAdmin 4 en Manjaro o ArchLinux

El objetivo de este artículo es enseñarte a instalar PostgreSQL y PGAdmin en la distribución Manjaro o ArchLinux.

### Requesitos

- Acceso a modo administrativo
- Tener instalado YAY (AUR Helper)


### Versiones de PostgreSQL disponibles

**Actualmente, Manjaro y ArchLinux de manera oficial** tienen soporte para la **versión 13.x de PostgreSQL**, esto se puede comprobar de la siguiente forma:

```
  $ pacman -Ss postgresql | grep extra/postgresql  
  
  ## Output
  extra/postgresql 13.3-3
  extra/postgresql-docs 13.3-3
  extra/postgresql-libs 13.3-3 [instalado]
  extra/postgresql-old-upgrade 12.8-1

```

A través del **YAY (AUR Helper)** se tiene soporte a PosgreSQL desde la versión 10 hasta la 12

- [PostgreSQL 10](https://aur.archlinux.org/packages/postgresql-10/)
- [PostgreSQL 11](https://aur.archlinux.org/packages/postgresql-11/)
- [PostgreSQL 12](https://aur.archlinux.org/packages/postgresql-12/)


### Instalación y Configuración de PostgreSQL 13 

```
  $ sudo pacman -S postgresql
```

Obtener la versión de PostgreSQL

```
  $ postgres --version
```

Al realizar la instalación de PostgreSQL el sistema crea un usuario llamado **postgres**, por consiguiente, se accederá a ese usuario.

```
  $ sudo -iu postgres

## o

  $ su -l postgres
```

Obtener la configuración de nuestra region para agregarla al siguiente comando

```
  $ locale 

  ## Output
  LANG=es_MX.UTF-8
  LC_CTYPE="es_MX.UTF-8"
  LC_NUMERIC=es_MX.UTF-8
  LC_TIME=es_MX.UTF-8
  LC_COLLATE="es_MX.UTF-8"
  LC_MONETARY=es_MX.UTF-8
  LC_MESSAGES="es_MX.UTF-8"
  LC_PAPER=es_MX.UTF-8
  LC_NAME=es_MX.UTF-8
  LC_ADDRESS=es_MX.UTF-8
  LC_TELEPHONE=es_MX.UTF-8
  LC_MEASUREMENT=es_MX.UTF-8
  LC_IDENTIFICATION=es_MX.UTF-8
  LC_ALL=
```

Inicializar el gestor de base de datos

```
  [postgres]$ initdb --locale=es_MX.UTF-8 -E UTF8 -D /var/lib/postgres/data
```

Muchas líneas deberían aparecer ahora en la pantalla con varias terminando por : ... ok

**Importante**

En caso de que al tratar de acceder al usuario **postgres** requira contraseña, deberá cambiarla mediante el siguiente comando.


```
  $ sudo passwd postgres
```
