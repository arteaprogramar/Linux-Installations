from src.util import Command


def unzip(path: str, directory_output: str):
    result = Command.execute(f'unzip {path} -d {directory_output}')

    if isinstance(result, bool):
        return result
    else:
        return True


def un_tar_gz(path: str, directory_output: str):
    result = Command.execute(f'tar zxvf {path} --directory {directory_output}')

    if isinstance(result, bool):
        return result
    else:
        return True


def un_tar_xz(path: str, directory_output: str):
    result = Command.execute(f'tar xf {path} --directory {directory_output}')

    if isinstance(result, bool):
        return result
    else:
        return True