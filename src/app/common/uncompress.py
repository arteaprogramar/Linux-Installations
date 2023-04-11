import os


def unzip(path: str, directoryOutput: str):
    os.system(f'unzip {path} -d {directoryOutput}')


def untar(path: str, directoryOutput: str):
    os.system(f'tar -xfv {path} --directory {directoryOutput}')


def un_tarxz(path: str, directoryOutput: str):
    os.system(f'tar xf {path} --directory {directoryOutput}')
