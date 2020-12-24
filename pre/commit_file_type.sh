#!/bin/bash

REPOS="$1"
TXN="$2"

SVNLOOK=/usr/bin/svnlook
CFG_VALUE="commit_file_type"
CFG_FILE="${REPOS}/hooks/hooks.cfg"

source <(grep = <(grep -A1 "\[${CFG_VALUE}\]" ${CFG_FILE}))

if [ -z "${!CFG_VALUE}" ]; then
    commit_file_type="*.avi$|*.mp4$|*.mkv$|*.rar$|*.zip$|*.pdf$"
fi

FILES=$($SVNLOOK changed -t "$TXN" "$REPOS")

OIFS=$IFS
IFS=$'\n'
for line in $FILES; do
    action=$(echo $line | tr -s " " | cut -d" " -f1)
    file=$(echo $line | tr -s " " | cut -d" " -f2-)

    if [ "$action" != "D" ]; then
        if [ "${file: -1}" != "/" ]; then
            if echo ${file} | grep -q -i -E "${commit_file_type}" ; then
                IFS=$OIFS
                echo ""
                echo "File $file has an extension not allowed." 1>&2
                echo -e "There are file types not allowed ("$(echo ${commit_file_type} | tr -d "*.$")")." 1>&2
                exit 1
            fi
        fi
    fi
done
IFS=$OIFS

exit 0
