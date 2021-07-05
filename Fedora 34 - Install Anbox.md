### Instalación de Anbox en Fedora 34

Requerimientos:

* Instalación del Gestor de Paquetes Snaps
* Instalación de Módulos Kernel
* Configuración de Módulos Kernel para Anbox
* Instalación de Anbox Snap
* Instalación de APK


#### ¿Que es Anbox?

Según su sitio oficial [AnboxIO](https://anbox.io/), Anbox es un software de código abierto que encapsula al Sistema Operativo Android en un contenedor LXC para que pueda acceder al hardware y otros servicios del sistema GNU/Linux host y así ejecutar  aplicaciones de manera nativa sin la lentitud de la virtualización.

#### ¿Que es LXC?

LinuX Containers, también conocido por el acrónimo LXC, es una tecnología de virtualización a nivel de sistema operativo para Linux. ... LXC no provee de una máquina virtual, más bien provee un entorno virtual que tiene su propio espacio de procesos y redes.


### Instalación del Gestor de Paquetes Snaps


```
	
	# Instalación mediante DNF
	$ sudo dnf install snapd

	# Habilitar de Snap Clasic
	$ sudo ln -s /var/lib/snapd/snap /snap

	# Verificar la versión de Snap
	$ snap version

	# Buscar un paquete
	$ snap search vlc

```

### Instalación de Módulos Kernel y dependencias


```
	
	$ sudo dnf install kernel-headers kernel-devel dkms gcc make perl bzip2 binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon

```

### Configuración de Módulos Kernel para Anbox


```
	
	# Clonación de Anbox-Modules
	$ cd ~
	$ git clone https://github.com/anbox/anbox-modules.git
	$ cd anbox-modules

	# Archivos de configuracion
	$ sudo cp anbox.conf /etc/modules-load.d/
	$ sudo cp 99-anbox.rules /lib/udev/rules.d/

	# Archivos de modulos
	$ sudo cp -rT ashmem /usr/src/anbox-ashmem-1
	$ sudo cp -rT binder /usr/src/anbox-binder-1

	# Construccion de modulos
	$ sudo dkms install anbox-ashmem/1
	$ sudo dkms install anbox-binder/1

	# Verificar modulos
	$ sudo modprobe ashmem_linux
	$ sudo modprobe binder_linux

```

### Instalación de Anbox Snap en Fedora Linux 34

```
	
	# Instalar
	$ sudo snap install --devmode --beta anbox

	# Actualizar 
	$ snap refresh --beta --devmode anbox

```


### Fedora SELinux Troubleshooter: Configuración

```

	$ sudo ausearch -c servicemanager --raw
	$ sudo semodule -X 300 -i my-servicemanager.pp
	$ sudo ausearch -c anboxd --raw
	$ sudo semodule -X 300 -i my-anboxd.pp
	$ sudo ausearch -c gatekeeperd --raw
	$ sudo semodule -X 300 -i my-gatekeeperd.pp

```

### Instalar una apliacion mediante ADB

```
	
	# Descargar plataform-tools version para linux
	# Desde esta página 

	$ cd Downloads
	$ wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
	$ unzip platform-tools-latest-linux.zip
	$ cd platform-tools/

	# Descargar un APK y pegan el archivo a esa carpeta  "platform-tools"
	# E instalan el archivo

	$ ./adb install xxxxxx.apk
```
