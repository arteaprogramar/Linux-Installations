from src.config import PackageManager, SystemInformation

_PYTHON_PIP = 'python-pip'


def install_python_pip():
    if PackageManager.pkg_exists(_PYTHON_PIP):
        return

    # SystemInformation.request_root_permission()
    manager = PackageManager.get_pm()

    if manager == PackageManager.DNF_MANAGER:
        PackageManager.dnf_install(_PYTHON_PIP)

    if manager == PackageManager.APT_MANAGER:
        PackageManager.apt_install(_PYTHON_PIP)

    if manager == PackageManager.PACMAN_MANAGER:
        PackageManager.pacman_install(_PYTHON_PIP)
