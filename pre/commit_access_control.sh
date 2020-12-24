#!/bin/bash

REPOS="$1"
TXN="$2"
SVNLOOK=/usr/bin/svnlook
CFG_PATH="/opt/csvn/hooks_scripts/pre"
ACCESS_CONTROL="${CFG_PATH}/commit_access_control.pl"
CONFIG="${REPOS}/hooks/commit_access_control.cfg"

# Check that the author of this commit has the rights to perform
# the commit on the files and directories being modified.
perl $ACCESS_CONTROL "$REPOS" "$TXN" $CONFIG || exit 1

exit 0
