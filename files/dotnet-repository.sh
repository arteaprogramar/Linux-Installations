#!/bin/sh

versions=("6" "7" "8")

if [ -z "$1" ]; then
    wget https://dot.net/v1/dotnet-install.sh -P temp  > /dev/null 2>&1
    chmod +x temp/dotnet-install.sh

    printf '%s\n' "${versions[@]}"
    exit 0
fi

dotnet_version=$1

for version in "${versions[@]}"; do
    if [ "$dotnet_version" = "$version" ]; then
        echo "Se instalará .NET $dotnet_version"
        sudo bash temp/dotnet-install.sh --runtime dotnet --version "$dotnet_version".0.0 --install-dir /usr/share/dotnet
        sudo bash temp/dotnet-install.sh --channel "$dotnet_version".0.1xx --install-dir /usr/share/dotnet
        exit 0
    fi
done

echo "Se ha seleccionado una opción invalida"
exit 1
