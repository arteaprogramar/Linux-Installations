from src.util import Command

packages = ['apt', 'dnf', 'pacman']

def get_package_manager():
    manager = ''

    for package in packages:
        result = package_exists(package)

        if result:
            manager = package

    return manager


def package_exists(name : str) :
    """
    Permite saber si un paquete existe atraves del argumento --version
    :param name:
    :return:
    """
    result = Command.execute(f"{name} --version", True, True)
    return isinstance(result, list)