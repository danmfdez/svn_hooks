#!/bin/bash

REPOS="$1"
REV="$2"

SVNLOOK=/usr/bin/svnlook
CURL=/usr/bin/curl
TOKEN="AUTOMATION"

JOBS="${REPOS}/hooks/commit_jenkins_job.ini"
JENKINS_URL=$(grep "^url" $JOBS | awk -F= '{print$2}')

#check if jenkins.ini has * (all directories)
source <(grep = <(grep -A1 "\[*\]" $JOBS))
if [ -n "$jobs" ]; then
	$CURL -X POST $JENKINS_URL/$jobs
        unset jobs
fi

#check dirs change
$SVNLOOK dirs-changed $REPOS --revision $REV \
    | sed 's%/.*%%' \
    | sort -u \
    | while read PROJ ; do
         source <(grep = <(grep -A1 "\[$PROJ\]" $JOBS))
         if [ -n "$jobs" ]; then
            $CURL -X POST $JENKINS_URL/$jobs
		    unset jobs
         fi
     done
exit 0
