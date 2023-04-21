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


getInformation = _SystemInformation()
