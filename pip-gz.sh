#!/bin/env bash
if [[ -z "$1" ]]; then
    echo "Usage: $0 <package>"
    exit 1
fi
python3.11 -m pip install $1.tar.gz
if [[ $? -ne 0 ]]; then
    exit 1
fi
rm -f $1.tar.gz