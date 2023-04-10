from src.app.gnu import adb


def gnu_adb(manager: str):
    adb.init(manager)
