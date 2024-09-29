#!/bin/sh

# Obtener el JSON de la URL
flutter_version=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json)

# Extraer las versiones estables
stable_versions=$(echo "$flutter_version" | awk -F'"' '/"channel": *"stable"/ {getline; print $4}' | grep -v '^$' | head -n 20)

# Mostrar las versiones estables
echo "$stable_versions"
