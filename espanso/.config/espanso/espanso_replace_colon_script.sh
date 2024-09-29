#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 inputfile outputfile"
    exit 1
fi

inputfile=$1
outputfile=$2

sed -E 's/:([^ :][^:]*):/;\1/g' "$inputfile" > "$outputfile"
