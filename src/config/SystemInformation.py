import os
import platform
import subprocess

from src.config import Printing, TemporalFile


class _SystemInformation:
    current_user_id = os.geteuid()
    kernel_version = platform.uname().release
    arch = platform.uname().machine
    object: dict = platform.freedesktop_os_release()

    def get_name_system(self):
        return self.object.get('NAME')

    def get_id_system(self):
        return self.object.get('id')

    def get_type_distro(self):
        return self.object.get('BUILD_ID')

    def get_kernel_version(self):
        return self.kernel_version

    def require_permission(self):
        return self.current_user_id == 0

    def get_arch(self):
        return self.arch


def has_root_permission():
    is_root = subprocess.check_output('echo "${EUID:-$(id -u)}"', shell=True, text=True)
    return int(is_root) == 0


def request_root_permission():
    if not has_root_permission():
        Printing.title("El script requiere permisos administrativos")
        # args = ['sudo', sys.executable] + sys.argv + [os.environ]
        # os.execlpe('sudo', *args)
        os.system('sudo uname -m')
        # subprocess.call(['sudo', 'cat', '/etc/os-release', '&>/dev/null'])


def permission_continue():
    print(has_root_permission())

    if has_root_permission():
        Printing.title('Se requieren permisos administrativos')
        TemporalFile.folder_delete(TemporalFile.FOLDER_TEMP)
        exit()


getInformation = _SystemInformation()
