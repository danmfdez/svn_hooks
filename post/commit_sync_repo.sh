#!/bin/bash

REPOS="$1"
REV="$2"

CFG_VALUE="commit_sync_repo"
CFG_FILE="${REPOS}/hooks/hooks.cfg"

source <(grep = <(grep -A1 "\[${CFG_VALUE}\]" ${CFG_FILE}))

if [ -z "${!CFG_VALUE}" ]; then
    echo ""
    echo "This repository has a synchronization configured in post hook, but destination repository is not defined."
    echo "Please, contact with administrators to fix the problem. Sorry for the inconvenience."

    exit 1
fi

SVNSYNC="/opt/csvn/bin/svnsync"
SYNC_USER=<user>
SYNC_PASS=<pass>

$SVNSYNC sync ${commit_sync_repo} --source-username ${SYNC_USER} --source-password ${SYNC_PASS} --sync-username ${SYNC_USER} --sync-password ${SYNC_PASS} --trust-server-cert --non-interactive --no-auth-cache >> /tmp/sync 2>&1

exit 0
