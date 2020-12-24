#!/bin/bash

REPOS="$1"
TXN="$2"

SVNLOOK=/usr/bin/svnlook
LOG_MSG_LINE1=$(${SVNLOOK} log -t ${TXN} "${REPOS}" | /usr/bin/head -n1)
JIRA_URL=""
BASIC_AUTH=""
ISSUE=$(echo $LOG_MSG_LINE1 | /usr/bin/cut -d "[" -f2 | /usr/bin/cut -d "]" -f1)
DATE=$(/bin/date '+%Y-%m-%d %H:%M')

if $(/usr/bin/curl -s -X GET -H "Authorization: Basic ${BASIC_AUTH}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/$ISSUE| grep --quiet "Issue Does Not Exist") ; then 
	echo "Issue not exist"
	exit 1
else
	JSON=$(/usr/bin/curl -s -X GET -H "Authorization: Basic ${BASIC_AUTH}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/$ISSUE | /usr/bin/jq -r '.fields.customfield_15115')

	#Example data="{\"update\": {\"customfield_15115\": [{\"set\": \"$JSON $DATE\"}]}}"
	/usr/bin/curl -s -X PUT -H "Authorization: Basic ${BASIC_AUTH}" --data "{\"update\": {\"customfield_15115\": [{\"set\": \"$JSON $DATE\"}]}}" -H "Content-Type: application/json" ${JIRA_URL}/rest/api/2/issue/$ISSUE
	exit 0
fi

