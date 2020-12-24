#!/bin/bash

REPOS="${1}"
TXN="${2}"
SVNLOOK=/usr/bin/svnlook
LOG_MSG_LINE1=$(${SVNLOOK} log -t "${TXN}" "${REPOS}" | /usr/bin/head -n1)
ISSUE=$(echo $LOG_MSG_LINE1 | /usr/bin/cut -d "[" -f2 | /usr/bin/cut -d "]" -f1)
JIRA_URL=""
BASIC_AUTH=""

if ((echo "${LOG_MSG_LINE1}" | egrep '^\[[a-zA-Z0-9]+[-][0-9]*\].*$' > /dev/null;) && ($(/usr/bin/curl -s -k -X GET -H "Authorization: Basic ${BASIC_AUTH}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/${ISSUE} | grep -v --quiet "Issue Does Not Exist"))) || (echo "${LOG_MSG_LINE1}" | egrep '^\[[nN][oO][jJ][iI][rR][aA]\].*$' > /dev/null;); then 
    #Issue exists
    exit 0
else
    echo ""
    echo "Your log message does not contain a JIRA Issue identifier (or bad format used)"
    echo "The JIRA Issue identifier must be the first item on the first line of the log message."
    echo ""
    echo "Proper JIRA format:  '[AAA-000]' or '[NOJIRA]'"

    exit 1
fi

