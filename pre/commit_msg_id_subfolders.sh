#!/bin/bash

REPOS="${1}"
TXN="${2}"
SVNLOOK=/usr/bin/svnlook
LOG_MSG_LINE1=$(${SVNLOOK} log -t "${TXN}" "${REPOS}" | /usr/bin/head -n1)
ISSUE=$(echo $LOG_MSG_LINE1 | /usr/bin/cut -d "[" -f2 | /usr/bin/cut -d "]" -f1)
ID_PATHS="${REPOS}/hooks/commit_msg_id_subfolders.ini"
NOT_ID_PATHS="${REPOS}/hooks/commit_msg_id_not_subfolders.ini"
JIRA_URL=""
BASIC_AUTH=""

# Functions
function checkID {
    if ((echo "${LOG_MSG_LINE1}" | egrep '^\[[a-zA-Z0-9]+[-][0-9]*\].*$' > /dev/null;) && ($(/usr/bin/curl -s -k -X GET -H "Authorization: Basic ${BASIC_AUTH}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/${ISSUE} | grep -v --quiet "Issue Does Not Exist"))) || (echo "${LOG_MSG_LINE1}" | egrep '^\[[nN][oO][jJ][iI][rR][aA]\].*$' > /dev/null;); then
        #Issue exists
        return 0
    else
        echo ""
        echo "Your log message does not contain a JIRA Issue identifier (or bad format used)"
        echo "The JIRA Issue identifier must be the first item on the first line of the log message."
        echo ""
        echo "Proper JIRA format:  '[AAA-000]' or '[NOJIRA]'"
        return 1
    fi
}

if [ -f $ID_PATHS ]; then
    $SVNLOOK dirs-changed $REPOS --transaction $TXN \
    | while read CPATH ; do
        # Check if ID needed
        if echo "$CPATH" | grep -q -f $ID_PATHS ; then
            # JIRA ID needed in commit message
            checkID
            exit $?
        fi
     done
elif [ -f $NOT_ID_PATHS ]; then
   $SVNLOOK dirs-changed $REPOS --transaction $TXN \
    | while read CPATH ; do
        # Check if ID not needed
        if echo "$CPATH" | grep -q -f $NOT_ID_PATHS ; then
            exit 0
        fi
        # ID not match and needed
        checkID
        exit $?	
     done
else
    # JIRA ID needed in commit message (all repository)
    checkID
    exit $?
fi

