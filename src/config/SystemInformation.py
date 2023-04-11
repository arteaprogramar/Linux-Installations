import os
import platform
import subprocess
import sys


class _SystemInformation:
    current_user_id = os.geteuid()
    kernel_version = platform.uname().release
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


def has_root_permission():
    return os.geteuid() == 0


def request_root_permission():
    if not has_root_permission():
        print("El script requiere permisos administrativos")
        # args = ['sudo', sys.executable] + sys.argv + [os.environ]
        # os.execlpe('sudo', *args)
        subprocess.call(['sudo', 'sudo', '--version', '&>/dev/null'])

    return has_root_permission()


getInformation = _SystemInformation()
