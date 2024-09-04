import os

from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation, Printing

_TITLE = 'Instalación de Postman'
_POSTMAN_PATH = '/opt/Postman'
_POSTMAN_PATH_ENTRY = '~/.local/share/applications/Postman.desktop'
_EXPORT_ENTRY = """[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/opt/Postman/app/Postman %U
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
"""



def init(manager: str):
    Printing.title(_TITLE)

    # Dependecias
    wget_installed = PackageManager.pkg_has_installed('Comprobar WGET', manager, 'wget')
    tar_installed = PackageManager.pkg_has_installed('Comprobar TAR', manager, 'tar')

    if not wget_installed & tar_installed:
        Printing.warning('Se requieren las depencias WGET y/o TAR para ejecutar este script')

    PackageManager.clear()
    start()



def start():
    Printing.welcome(_TITLE)
    Printing.message('WGET y TAR estan disponibles en el script')

    Printing.title('Crear carpeta temporal')
    temp_created = TemporalFile.temp_folder_create()

    if not temp_created:
        Printing.warning('No se ha podido crear la carpeta temporal')
        return

    Printing.title('Descargar Postman')
    wget_util.download('https://dl.pstmn.io/download/latest/linux_64')

    Printing.title('Descomprimir Postman')
    uncompress.un_targz(f'{TemporalFile.FOLDER_TEMP}/linux_64', TemporalFile.FOLDER_TEMP)

    Printing.title('Mover Postman a /opt/')
    # SystemInformation.request_root_permission()
    os.system(f'sudo mv temp/Postman {_POSTMAN_PATH}')

    Printing.title('Crear entrada Postman')
    os.system(f'echo """{_EXPORT_ENTRY}""" | tee -a {_POSTMAN_PATH_ENTRY}')

    Printing.title('Nota')
    Printing.warning('Asegurese de tener instalado openssl en su ordenador')
    Printing.message('https://learning.postman.com/docs/getting-started/installation/installation-and-updates/#linux-installation-notes')
    TemporalFile.folder_delete('temp')

