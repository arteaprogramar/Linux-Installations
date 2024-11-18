#!/bin/sh

gradle_url=$(curl -s https://raw.githubusercontent.com/gradle/gradle/master/released-versions.json)
versions=$(echo "$gradle_url" | sed -n '/"finalReleases": \[/,/\]/p' | grep -oP '"version":\s*"\K[0-9.]+' | grep -v '^$' | head -n 20)

# Mostrar los resultados
printf '%s\n' "${versions[@]}"