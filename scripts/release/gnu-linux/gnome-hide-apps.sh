#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Ocultar aplicaciones innecesarios de Gnome Desktop" "1.0"
loggerBold "*Este script ha sido probado en EndeavourOS y Fedora*"

# Comprobar si script se esta ejecutando como usuario root
if [[ $(getUser) != "root" ]]; then
    userRootRequired
    exit
fi

proper="
NoDisplay=true\n
Hidden=true
"

loggerBold "\n\nOcultar aplicaciones de Avahi"
echo -e $proper >> /usr/share/applications/avahi-discover.desktop
echo -e $proper >> /usr/share/applications/bssh.desktop
echo -e $proper >> /usr/share/applications/bvnc.desktop
echo -e $proper >> /usr/share/applications/nm-connection-editor.desktop

loggerBold "\n\nOcultar aplicacion de PowerStadistic"
echo -e $proper >> /usr/share/applications/org.gnome.PowerStats.desktop

loggerBold "\n\nOcultar aplicacion de Token"
echo -e $proper >> /usr/share/applications/stoken-gui.desktop
echo -e $proper >> /usr/share/applications/stoken-gui-small.desktop

loggerBold "\n\nOcultar aplicacion de Gnome Mobile"
echo -e $proper >> /usr/share/applications/org.gnome.SettingsDaemon.Sharing.desktop
echo -e $proper >> /usr/share/applications/org.gnome.SettingsDaemon.Smartcard.desktop
echo -e $proper >> /usr/share/applications/org.gnome.SettingsDaemon.Wwan.desktop
echo -e $proper >> /usr/share/applications/org.gnome.SettingsDaemon.Wacom.desktop

loggerBold "\n\nOcultar aplicacion de Gnome-Tracker"
mv /usr/lib/tracker-miner-fs-3 /usr/lib/tracker-miner-fs-3-disable
echo -e $proper >> /etc/xdg/autostart/tracker-extract.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-miner-apps.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-miner-fs.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-miner-fs-3.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-miner-rss-3.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-miner-user-guides.desktop
echo -e $proper >> /etc/xdg/autostart/tracker-store.desktop

dbus-launch --exit-with-session gsettings set org.freedesktop.Tracker.Miner.Files crawling-interval -2
dbus-launch --exit-with-session gsettings set org.freedesktop.Tracker.Miner.Files enable-monitors false
yes | LANG=C tracker reset --hard
sed -i 's/X-GNOME-Autostart-enabled=.*/X-Gnome-Autostart-enabled=false/' /etc/xdg/autostart/tracker*.desktop