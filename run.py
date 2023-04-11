from src.app.gnu import adb, flutter


def gnu_adb(manager: str):
    adb.init(manager)


def gnu_flutter(manager: str):
    flutter.init(manager)