import os

FOLDER_TEMP = 'temp'


def folder_exists(path: str):
    return os.path.exists(path)


def temp_folder_create():
    try:
        if not folder_exists(FOLDER_TEMP):
            os.makedirs(FOLDER_TEMP)
            # os.chmod(FOLDER_TEMP, 0o777)

        return folder_exists(FOLDER_TEMP)
    except OSError:
        return False


def folder_delete(path: str):
    try:
        if folder_exists(path):
            os.removedirs(path)

        return not folder_exists(path)
    except OSError:
        return False
