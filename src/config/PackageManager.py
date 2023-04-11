import os
import subprocess

APT_MANAGER = 'apt'
DNF_MANAGER = 'dnf'
YAY_MANAGER = 'yay'
PACMAN_MANAGER = 'pacman'


def get_pm():
    _manager = ''

    for manager in [DNF_MANAGER, PACMAN_MANAGER, APT_MANAGER]:
        if pkg_exists(manager):
            _manager = manager
            break

    return _manager


def dnf_install(pkg: str):
    os.system(f'sudo dnf install -y {pkg}')


def apt_install(pkg: str):
    os.system(f'sudo apt install -y {pkg}')


def pacman_install(pkg: str):
    os.system(f'sudo pacman -S {pkg} --noconfirm')


def yay_install(pkg: str):
    os.system(f'sudo yay -S {pkg} --noconfirm')


def try_install(manager: str, pkg: str):
    try_installed = False

    if manager == APT_MANAGER:
        try_installed = True
        apt_install(pkg)

    if manager == DNF_MANAGER:
        try_installed = True
        dnf_install(pkg)

    if manager == PACMAN_MANAGER:
        try_installed = True
        pacman_install(pkg)

    return try_installed


def pkg_exists(pkg: str):
    try:
        # os.system(f'{pkg} --version &>/dev/null')
        subprocess.call([pkg, '--version', '&>/dev/null'])
        return True
    except OSError:
        return False


def pkg_has_installed(title: str, manager: str, pkg: str):
    printing.title(title)
    installed = pkg_exists(pkg)

    if not installed:
        try_install(manager, pkg)

    return pkg_exists(pkg)


def clear():
    subprocess.call(['clear'])
