
## Fedora 34 | Instalación de MySQL 5.7

Documentación
- [A Quick Guide to Using the MySQL Yum Repository](https://dev.mysql.com/doc/mysql-yum-repo-quick-guide/en/)

Requisito
- Acceso Root
- Conexión a Internet


### Instalación de mysql-community.repo

- Descargar e instalar MySQL Repository

```sh
## Fedora 35
$ sudo dnf install http://repo.mysql.com/mysql80-community-release-fc35.rpm

## Fedora 34
$ sudo dnf install http://repo.mysql.com/mysql80-community-release-fc34.rpm

```


- Modificar `mysql-community.repo` en la siguiente ruta `/etc/yum.repos.d/mysql-community.repo`

```

$ sudo nano  /etc/yum.repos.d/mysql-community.repo

# Quitar
[mysql80-community]
name=MySQL 8.0 Community Server
baseurl=http://repo.mysql.com/yum/mysql-8.0-community/fc/$releasever/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

# Reemplazar por
# Enable to use MySQL 5.7
[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/fc/31/$basearch/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql

```

### Instalación de MySQL

```
$ sudo dnf install mysql-community-server 

```


### Comenzar y conocer el servicio de MySQL

```
$ sudo systemctl start mysqld

$ sudo systemctl status mysqld

```


### Configuración de MySQL

Establecer una contraseña al servicio de MySQL

- Obtener una contraseña temporal para acceder a sevicio de MySQL

```

$  sudo grep 'temporary password' /var/log/mysqld.log

```

- Ingresar al servicio de MySQL y posteriormente cambiar la contraseña

```

$  mysql -uroot -p


## Cambiar contraseña con la siguiente sentencia SQL
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';


```


### Protección de MYSQL al instalar

```

$ /usr/bin/mysql_secure_installation


```

### Configuración del Firewall para conexiones remotas

```

$ sudo firewall-cmd --permanent --zone=public --add-service=mysql
$ sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
$ sudo systemctl restart firewalld.service
$ sudo systemctl restart mysqld

```
