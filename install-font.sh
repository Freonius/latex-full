#!/bin/env bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 <font>"
    exit 1
fi

FONT_FILE="$1"

if [[ "${FONT_FILE}" == *.ttf || "${FONT_FILE}" == *.zip ]]; then
    echo "OK"
else
    if [[ -f "${FONT_FILE}.ttf" ]]; then
        FONT_FILE="${FONT_FILE}.ttf"
        elif [[ -f "${FONT_FILE}.zip" ]]; then
        FONT_FILE="${FONT_FILE}.zip"
    else
        echo "File not found"
        exit 1
    fi
fi

if [[ ! -d /usr/local/share/fonts/ ]]; then
    mkdir -p /usr/local/share/fonts
fi
if [[ ! -d /usr/local/share/fonts/TTF ]]; then
    mkdir -p /usr/local/share/fonts/TTF
fi

if [[ "${FONT_FILE}" == *.zip ]]; then
    # create a temporary directory
    temp_dir=$(mktemp -d)
    
    # extract the zip file into the temporary directory
    unzip -d "$temp_dir" ${FONT_FILE}
    
    # traverse recursively into the subfolder and run commands on every .ttf file found
    find "$temp_dir" -name '*.ttf' -exec bash -c '
        cp "$1" /usr/local/share/fonts/TTF/
        mv "$1" /usr/local/share/fonts/
    ' -- {} \;
    
    # remove the temporary directory
    rm -rf "$temp_dir"
else
    cp "${FONT_FILE}" /usr/local/share/fonts/TTF/
    mv "${FONT_FILE}" /usr/local/share/fonts/
fi
fc-cache -f -v