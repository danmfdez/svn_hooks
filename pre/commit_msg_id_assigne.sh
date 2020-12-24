#!/bin/bash

REPOS="${1}"
TXN="${2}"
SVNLOOK=/usr/bin/svnlook
LOG_MSG_LINE1=$(${SVNLOOK} log -t "${TXN}" "${REPOS}" | /usr/bin/head -n1)
ISSUE=$(echo $LOG_MSG_LINE1 | /usr/bin/cut -d "[" -f2 | /usr/bin/cut -d "]" -f1)

JIRA_URL=""
BASIC_AUTH=""
ISSUE_QUERY=$(/usr/bin/curl -s -k -X GET -H "Authorization: Basic ${BASIC_AUTH}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/${ISSUE})

if ((echo "${LOG_MSG_LINE1}" | egrep '^\[[a-zA-Z0-9]+[-][0-9]*\].*$' > /dev/null;) && ($(echo ${ISSUE_QUERY} | grep -v --quiet "Issue Does Not Exist"))) || (echo "${LOG_MSG_LINE1}" | egrep '^\[[nN][oO][jJ][iI][rR][aA]\].*$' > /dev/null;); then 
    if !(echo "${LOG_MSG_LINE1}" | egrep -q '^\[[nN][oO][jJ][iI][rR][aA]\].*$'); then
        #Issue exists
        #Check assignee
        ASSIGNEE=$(echo ${ISSUE_QUERY} | jq '.fields.assignee.name' | tr -d '"' | awk '{ print toupper($0) }')
        SVN_USER=$(${SVNLOOK} author "$REPOS" | awk '{ print toupper($0) }')

        if [ "${SVN_USER}" != "${ASSIGNEE}" ]; then
            echo ""
            echo "The assignee of the $ISSUE issue is ${ASSIGNEE} and it is not you (${SVN_USER})."
            echo "You can not committing in issues where you are not the assignee."
            exit 1
        fi
    fi
else
    echo ""
    echo "Your log message does not contain a JIRA Issue identifier (or bad format used)"
    echo "The JIRA Issue identifier must be the first item on the first line of the log message."
    echo ""
    echo "Proper JIRA format:  '[AAA-000]' or '[NOJIRA]'"

    exit 1
fi

exit 0
