#!/bin/bash

REPOS="$1"
TXN="$2"

SVNLOOK=/usr/bin/svnlook
CFG_VALUE="commit_msg_length"
CFG_FILE="${REPOS}/hooks/hooks.cfg"

LOGMSG=$($SVNLOOK log -t "$TXN" "$REPOS" | grep [a-zA-Z0-9] | wc -c)

source <(grep = <(grep -A1 "\[${CFG_VALUE}\]" ${CFG_FILE}))

if [ -z "$((${CFG_VALUE}))" ]; then
    commit_length=5
else
    commit_length=$((${CFG_VALUE}))
fi

#Check that commit message is more than X characters long
if [ "$LOGMSG" -lt ${commit_length} ]; then
	echo -e "Please provide a meaningful comment when committing changes. More than ${commit_length} characters are required." 1>&2
	exit 1
fi

exit 0
