
## Fedora 33+ | Instalación de Postgresql 12 y PGAdmin4

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
# Configuración del archivo "postgresql.conf" mediante "nano"
$ sudo nano /var/lib/pgsql/12/data/postgresql.conf

# Se buscará la linea con la  siguiente instrucción  "  #listen_addresses=’listen’  "
# Se modificara de la siguiente manera
listen_addresses = '*'

# Configuración del archivo "pg_hba.conf" mediante "nano"
$ sudo vi /var/lib/pgsql/11/data/pg_hba.conf

# Se modificara la linea que contiene la conexion de "IPv4"
# host         all         all         127.0.0.1/32         ident
# A 
host         all         all         127.0.0.1/32         md5

# Además se agregará una nueva conexión debajo de la linea anterior con la IP del Servidor POstgresql
host         all         all         xxx.xxx.xxx.xxx/32   md5

```
