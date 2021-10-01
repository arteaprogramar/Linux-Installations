## Instalación de Apache Server y PHP 7.4 en Manjaro 21

El objetivo de esta publicación es mostrarte como puedes instalar PHP 7.4 con el Servidor Apache.

### Requisitos
- Acceso administrativo
- Tener instalado [**gedit**](https://wiki.gnome.org/Apps/Gedit) o cualquier otro editor de texto como el paquete **nano** para la terminal.

### Instalación y Configuración de Apache Server

Instalación

```
  $ sudo pacman -S apache
```

Configuracion: Se editará el archivo `/etc/httpd/conf/httpd.conf` mediante **nano** o **gedit**

```
  ## Para abrir el archivo con nano
  $ sudo nano /etc/httpd/conf/httpd.conf
  
  ## Para abrir el archivo con gedit
  $ sudo gedit /etc/httpd/conf/httpd.conf
```

Abierto el archivo se buscará la siguiente linea `LoadModule unique_id_module modules/mod_unique_id.so` y se procederá a comentarla si aun no lo esta, quedando de la siguiente forma

```
  [...]
  # LoadModule unique_id_module modules/mod_unique_id.so
  [...]
```

Ahora solo guarde los cambio y proceda a iniciar el Apache Server

```
  $ sudo systemctl start httpd
  
  ## Comprobar estado de Apache Server
  $ sudo systemctl start httpd
```


### Instalación de PHP 7.4

A diferencia de otras distribuciones en Manjaro se le da prioridad a las nuevas versiones de cualquier paquete, por consiguiente, actualmente el comando `sudo pacman -S php php-apache` instalar la versión de PHP 8.0.
Sí se desea instalar una versión de PHP 7.x solo conseguiremos obtener PHP 7.4


Instalación de PHP 7.4

```
  $ sudo pacman -S php7 php7-apache
  
  ## Obtener la versión de PHP
  $ php -v
  
  ## O en su defecto si no funciona intentar con
  $ php7 -v
```

Instalación de PHP Extensions

```
  $ sudo pacman -S php7-apache php7-cgi php7-dblib php7-embed php7-enchant php7-fpm php7-gd php7-imap php7-intl php7-odbc php7-pgsql php7-phpdbg php7-pspell php7-snmp php7-sodium php7-sqlite php7-tidy php7-xsl php7-mongodb php7-memcache   
```

Configuración

Se modificara el siguiente archivo `/etc/httpd/conf/httpd.conf` mediante **nano** o **gedit**
 
```
   ## Para abrir el archivo con nano
  $ sudo nano /etc/httpd/conf/httpd.conf
  
  ## Para abrir el archivo con gedit
  $ sudo gedit /etc/httpd/conf/httpd.conf
```


Abierto el archivo se buscará la siguiente linea `LoadModule mpm_event_module modules/mod_mpm_event.so` y se procederá a comentarla si aun no lo esta, quedando de la siguiente forma

```
  [...]
  #LoadModule mpm_event_module modules/mod_mpm_event.so
  [...]
```

Se agregaran las siguientes lineas al final del archivo

```
  [...]
  LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
  
  ## Para PHP 7.x
  LoadModule php7_module modules/libphp7.so
  AddHandler php7-script php
  Include conf/extra/php7_module.conf
  
  ## Opcional
  <IfModule dir_module>
      <IfModule php7_module>
  	      DirectoryIndex index.php index.html
  	      <FilesMatch "\.php$">
  		        SetHandler application/x-httpd-php
  	      </FilesMatch>
  	      <FilesMatch "\.phps$">
  		        SetHandler application/x-httpd-php-source
  	      </FilesMatch>
      </IfModule>
  </IfModule>

```

Reinicie el Apache Server

```
  $ sudo systemctl restart httpd
  
  ## Comprobar estado de Apache Server
  $ sudo systemctl status httpd
```

### Testeo

Crear un archivo mediante en la siguiente ruta nano `/srv/http/index.php` que corresponde a nuestro servidor, posteriomente se agregara el siguiente código.

```
<?php
 phpinfo();
?>
```
