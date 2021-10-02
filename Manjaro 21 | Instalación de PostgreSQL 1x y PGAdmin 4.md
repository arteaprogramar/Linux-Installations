## Instalación de PostgreSQL 1x en Manjaro o ArchLinux

El objetivo de este artículo es enseñarte a instalar PostgreSQL y PGAdmin en la distribución Manjaro o ArchLinux.

### Requesitos

- Acceso a modo administrativo
- Tener instalado YAY (AUR Helper)
- Tener instalado gedit o cualquier otro editor de texto como el paquete nano para la terminal.


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


Ejecutar la herramienta de administracion por consola para cambiar contraseña

```
  [postgres]$ psql
  [postgres]$ ALTER USER postgres WITH password 'xxxx';
```

**Importante**

En caso de que al tratar de acceder al usuario **postgres** requira contraseña, deberá cambiarla mediante el siguiente comando.


```
  $ sudo passwd postgres
```

**Configurar postgresql.conf**

Para tener acceso remoto a PostgreSQL es necesario editar dos archivos de configuración: `/var/lib/postgres/data/postgresql.conf` y `/var/lib/postgres/data/pg_hba.conf`

Se modificara el siguiente archivo `/var/lib/postgres/data/postgresql.conf` mediante nano o gedit

```
  $ sudo nano /var/lib/postgres/data/postgresql.conf
  $ sudo gedit /var/lib/postgres/data/postgresql.conf
```

Se buscará la linea con la siguiente instrucción  ` #listen_addresses=’listen’ ` y se modificará de la siguiente manera:

```
listen_addresses = '*'
```

**Configurar pg_hba.conf**

Obtener la dirección IP donde se encuentra alojado PostgreSQL

```
  ## Obtener direccion IP
  $ ip addr | grep inet 
  
  ## Output
  inet 127.0.0.1/8 scope host lo
  inet6 ::1/128 scope host 
  inet 192.168.0.39/24 brd 192.168.0.255 scope global dynamic noprefixroute wlp3s0
  inet6 2806:268:2401:829f:8b5d:6c58:6f4e:2f0d/64 scope global dynamic noprefixroute 
  inet6 fe80::1ae3:6df:f41f:159e/64 scope link noprefixroute 
```

Se modificara el siguiente archivo `/var/lib/postgres/data/pg_hba.conf` mediante nano o gedit

```
  $ sudo nano /var/lib/postgres/data/pg_hba.conf
  $ sudo gedit /var/lib/postgres/data/pg_hba.conf
```

Edite y establezca el método de autenticación para cada usuario *scram-sha-256* o *md5* en las conexiones IPv4

```
  # TYPE  DATABASE        USER            ADDRESS                 METHOD                                                                                               
  # "local" is for Unix domain socket connections only                                                                                                                        
  local   all             user                                    scram-sha-256
```

Agrega al archivo la siguiente linea en donde reemplazara *xxx.xxx.xxx.xxx/xx* por su dirección IP.

```
  host         all         all         xxx.xxx.xxx.xxx/xx           md5
```

### Post-Instalación

```
   $ sudo systemctl restart postgresql.service
   $ sudo systemctl status postgresql.service
```

