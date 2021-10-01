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
