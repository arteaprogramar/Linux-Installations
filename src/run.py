from src.app.gnu import adb, flutter, gradle
from src.app.pacman import java, mysql, mtp, browser, php


def gnu_adb(manager: str):
    adb.init(manager)


def gnu_flutter(manager: str):
    flutter.init(manager)


def gnu_gradle(manager: str):
    gradle.init(manager)


def pacman_java(manager: str):
    java.init(manager)


def pacman_mysql(manager: str):
    mysql.init(manager)


def pacman_mtp(manager: str):
    mtp.init(manager)


def pacman_browser(manager: str):
    browser.init(manager)


def pacman_php(manager: str):
    php.init(manager)

