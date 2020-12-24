Pre-commit

|Name|Description|Config Files (You need to edit)|Parameters used (hooks.cfg)|Files (Do not edit)|
|----|-----------|------|------------------------|---------------------------|-------------------|
| commit_access_control | Check that the author of this commit has the rights to perform the commit. | commit_access_control.cfg | - Directory - Users - Permissions | - commit_access_control.pl - commit_access_control.sh |



| commit_msg_length Check log message (Make sure that the log message contains some text and check that the commit message is more than 5 characters) |
| commit_msg_id | Check if the commit message has a JIRA key and if it exists or have introduced [NOJIRA] |
| 

Minimum
message
length commit_ms
g_length.sh
commit_ms
g_id.sh
commit_ms
Check if the commit message has a JIRA key, if that key exists and if the author of the commit
g_id_assigne is the ticket assignee or if they have entered [NOJIRA] in the commit message.
commit_file_
type Check the file type and do not allow commit if it is avi, mp4, mkv, rar, zip, pdf ...
commit_ma
x_size Check the size of the files and if it is larger than X, do not let commit.
commit_ms
g_id_assig
ne.sh
File types
list commit_file
_type.sh
Maximum
file size commit_ma
x_size.sh
