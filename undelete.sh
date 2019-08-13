#!/bin/bash
git log --pretty=format: --name-only --diff-filter=A | sort -u | while read FILE
do
    if [ -e "$FILE" ]; then
        continue
    fi
    FILES=()
    while [ ! -z "$FILE" ] && [ ! "." == "$FILE" ] && [ ! "/" == "$FILE" ]; do
        FILE=$(dirname "$FILE")
        FILES=("$FILE" "${FILES[@]}")
    done
    for FILE in "${FILES[@]}"; do
        if [ ! -e "$FILE" ]; then
            HASH=$(git rev-list -n 1 HEAD -- "$FILE")
            if [ ! -z $HASH ]; then
                echo $FILE
                git checkout $HASH^ -- "$FILE"
            fi
        fi
    done
done