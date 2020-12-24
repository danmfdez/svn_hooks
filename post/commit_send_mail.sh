#!/bin/bash

REPOS="$1"
REV="$2"

SVNLOOK=/usr/bin/svnlook
#Perl script for sendmail
CFG_PATH="/opt/csvn/hooks_scripts/post"
ACCESS_CONTROL="${CFG_PATH}/commit_send_mail.pl"
#Config file with emails
USERS_EMAILS="${REPOS}/hooks/commit_send_mail.ini"

#Check dirs change
$SVNLOOK dirs-changed $REPOS --revision $REV \
    | sed 's%/.*%%' \
    | sort -u \
    | while read PROJ ; do
	 source <(grep = <(grep -A1 "\[$PROJ\]" $USERS_EMAILS))
         if [ -n "$mails" ]; then
              #Send mail when post-commit
	      perl $COMMIT_EMAIL "$REPOS" "$REV" --from no-reply@svn.info $mails -s "[SVN]"
         fi
     done

exit 0

# To find files instead of dirs:
# Replace: 'dirs-changed' by 'changed'
# Replace: sed 's%/.*%%' by  sed 's%.*\/%%'

