#!/bin/bash

CUR_DIR=$(pwd)

if [[ -z "$(command -v kpackagetool6)" ]]; then
    echo "kpackagetool6 not found. Stopping."
    exit
fi

function install_plasmoid {
    PLASMOID=$(basename "$1")

    INSTALLED=$(kpackagetool6 -l -t "Plasma/Applet" | grep $PLASMOID)
    if [[ -z "$INSTALLED" ]]; then
        echo "$PLASMOID isn't installed, installing normally..."
        kpackagetool6 -t "Plasma/Applet" -i "$1"
    else
        echo "$PLASMOID found, upgrading..."
        kpackagetool6 -t "Plasma/Applet" -u "$1"
    fi
    echo -e "\n"
    cd "$CUR_DIR"
}

for filename in "$PWD/plasmoids/"*; do
    install_plasmoid "$filename"
done

