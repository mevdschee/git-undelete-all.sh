#!/bin/bash
verbose=false
silent=false

while getopts 'hsv' flag; do
    case "${flag}" in
        v)  verbose=true ;;
        s)  silent=true ;;
        *)  echo "Usage git-undelete-all [OPTION...]"
            echo
            echo "  -h  help: print this usage information"
            echo "  -s  silent: do not print output"
            echo "  -v  verbose: print every file recovered"
            exit 1 ;;
    esac
done

start_time=$(date +%s)
file_count=0
while read file; do
    ((file_count++)) 
    if [ "true" == "$verbose" ]; then
        echo $file
    fi
    if [ "false" == "$silent" ] && [ "false" == "$verbose" ]; then
        printf "\r$file_count files restored"
    fi
    if [ -e "$file" ]; then
        continue
    fi
    files=()
    while [ ! -z "$file" ] && [ ! "." == "$file" ] && [ ! "/" == "$file" ]; do
        file=$(dirname "$file")
        files=("$file" "${files[@]}")
    done
    for file in "${files[@]}"; do
        if [ ! -e "$file" ]; then
            hash=$(git rev-list -n 1 HEAD -- "$file")
            if [ ! -z $hash ]; then
                git checkout $hash^ -- "$file"
            fi
        fi
    done
done < <(git log --pretty=format: --name-only --diff-filter=A | sort -u)

if [ "false" == "$silent" ] && [ "false" == "$verbose" ]; then
    end_time=$(date +%s)
    printf " in $(($end_time - $start_time)) seconds\n" 
fi
