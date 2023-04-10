import os


def unzip(path: str, directoryOutput: str):
    os.system(f'unzip {path} -d {directoryOutput}')