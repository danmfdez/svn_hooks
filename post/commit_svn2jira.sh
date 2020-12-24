#!/usr/bin/env bash

REPOS="$1"
REV="$2"

# define required vars
python_path=$(/usr/bin/env python)
svn_hook=$(dirname $0)/commit_svn2jira.py

# execute
${python_path} ${svn_hook} --config "$(dirname $0)/commit_svn2jira.json" --repos ${REPOS} --rev ${REV}

#if [ $? -ne 0 ]; then
#    exit 1
#fi

exit 0

