import os

from src.config import TemporalFile


def download(url: str):
    os.system(f'wget {url} -P {TemporalFile.FOLDER_TEMP}')
    return True
