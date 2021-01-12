
## Instalación de Postgresql

```

$ sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/F-33-x86_64/pgdg-fedora-repo-latest.noarch.rpm$ 
$ sudo dnf install -y postgresql12-server
$ sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
$ sudo systemctl enable postgresql-12
$ sudo systemctl start postgresql-12

```

## Post-installation

```

# Cambiar contraseña del usuario Postgres

$ sudo passwd postgres

```

## Entrar al usuario Postgres

```
$ su - postgres

# Ejecutar la herramienta de administracion por consola para cambiar contraseña

$ psql
$ ALTER USER postgres WITH password 'xxxx';

```


## Instalación de PGAdmin

```

$ sudo rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-fedora-repo-1-1.noarch.rpm
$ sudo yum install pgadmin4


```

## Post-installation de PgAdmin

Para tener acceso remoto a PostgreSQL es necesario editar dos archivos de configuración: postgresql.conf y pg_hba.conf

```
# postgresql.conf
$ sudo nano /var/lib/pgsql/12/data/postgresql.conf
# Buscamos la linea que dice  listen_addresses=’listen’ y lo descomentamos
listen_addresses = '*'

# pg_hba.conf
$ sudo vi /var/lib/pgsql/11/data/pg_hba.conf
# alteramos una linea para que sea del tipo md5. Y aidcionamos otra linea que contenga el IP desde donde vamos a hacer la conexión remota (por ejemplo: 192.168.0.77).


```
