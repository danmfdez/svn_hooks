# Pre-commit
Name | Description | Config Files (You need to edit) | Parameters to modify  | Files (Do not edit)
---- | ----------- | ------------------------------- | --------------------- | ------------------- 
commit_access_control | Check that the author of this commit has the rights to perform the commit. | commit_access_control.cfg | <ul><li>Directory</li><li>Users</li><li>Permissions</li></ul> | <ul><li>commit_access_control.pl</li><li>commit_access_control</li></ul>
commit_msg_length | Check log message (Make sure that the log message contains some text and check that the commit message is more than 5 characters). | | <ul><li>Minimum message length</li></ul> | <ul><li>commit_msg_length.sh</li></ul>
commit_msg_id | Check if the commit message has a JIRA key and if it exists or have introduced [NOJIRA]. | | | <ul><li>commit_msg_id.sh</li></ul>
commit_msg_id_assigne | Check if the commit message has a JIRA key, if that key exists and if the author of the commit is the ticket assignee or if they have entered [NOJIRA] in the commit message. | | | <ul><li>commit_msg_id_assigne.sh</li></ul>
commit_file_type | Check the file type and do not allow commit if it is avi, mp4, mkv, rar, zip, pdf... | | <ul><li>File types list</li></ul> | <ul><li>commit_file_type.sh</li></ul>
commit_max_size | Check the size of the files and if it is larger than X, do not let commit. | | <ul><li>Maximum file size</li></ul> | <ul><li>commit_max_size.sh</li></ul>

# Post-commit
Name | Description | Config Files (You need to edit) | Parameters to modify | Files (Do not edit)
---- | ----------- | ------------------------------- | -------------------- | ------------------- 
commit_jenkins_job | Runs a Jenkins job when committing. | <ul><li>commit_jenkins_job.ini</li></ul>  | <ul><li>Directory</li><li>Job to run</li></ul> | <ul><li>commit_jenkins_job.sh</li></ul>
commit_send_mail | Send emails when a commit is made. | <ul><li>commit_send_mail.ini</li></ul>  | <ul><li>Directory</li><li>E-mails</li></ul> | <ul><li>commit_send_mail.pl</li><li>commit_send_mail.sh</li></ul>
commit_svn2jira | Send commit message to JIRA ticket. When making a Commit informing the Issue ID in the format [XXX-05], the action will be published in the SCM Activity tab of the Issue, informing: <ul><li>The revision.</li><li>Who and when the commit was made.</li><li>The message of the commit.</li></ul> | <ul><li>commit_svn2jira.json</li></ul> | | <ul><li>commit_svn2jira.py</li><li>commit_svn2jira.sh</li></ul>
commit_sync_repo | Synchronize SVN repository or part of it with other SVN repository every time a commit is made in the source repository. | | <ul><li>Destination repository</li></ul>  | <ul><li>commit_sync_repo.sh</li></ul> 
