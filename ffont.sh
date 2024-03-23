#!/bin/env bash
if [[ -z "$1" ]]; then
    echo "Usage: $0 <text>"
    exit 1
fi

fc-list :family | grep $1 | sed 's/.*:\(.*\):.*/\1/' | sed 's/.*://' | sed 's/,[^,]*$//' | sed 's/^ *//;s/ *$//' | awk '!seen[$0]++'
