#!/bin/bash

REPOS="$1"
TXN="$2"

SVNLOOK=/usr/bin/svnlook
CFG_VALUE="commit_max_size"
CFG_FILE="${REPOS}/hooks/hooks.cfg"

source <(grep = <(grep -A1 "\[${CFG_VALUE}\]" ${CFG_FILE}))

if [ -z "${!CFG_VALUE}" ]; then
    commit_max_size=10485760
fi

FILES=$($SVNLOOK changed -t "$TXN" "$REPOS")

OIFS=$IFS
IFS=$'\n'
for line in $FILES; do
    action=$(echo $line | tr -s " " | cut -d" " -f1)
    file=$(echo $line | tr -s " " | cut -d" " -f2-)

    if [ "$action" != "D" ]; then
        if [ "${file: -1}" != "/" ]; then 
            FILE_SIZE=$($SVNLOOK filesize -t "$TXN" "$REPOS" "$file")

            if [ ${FILE_SIZE} -gt ${commit_max_size} ]; then
                IFS=$OIFS
                echo ""
                echo -e "There are files larger in size than the one accepted (${commit_max_size} bytes)." 1>&2
                exit 1
            fi 
        fi
    fi
done
IFS=$OIFS

exit 0
