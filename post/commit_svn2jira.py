#!/usr/bin/env python

__author__  = "scmenthusiast@gmail.com"
__version__ = "1.0"

from jira_commit_lib import JiraCommitHook
from jira_commit_lib import ScmActivity
from json import load, loads, dumps
import argparse
import sys
import os


class SvnPostCommitHook(object):

    def __init__(self, config):
        """
        __init__(). prepares or initiates configuration file
        :return: None
        """

        if not config: # default config file
            config = "commit_svn2jira.json"

        self.config_file = os.path.join(os.path.dirname(__file__), config)

        if self.config_file and os.path.exists(self.config_file):
            try:
                configuration = load(open(self.config_file))

                self.svn_server_web = configuration.get("svn.server.web")
                self.svn_branch_tags = configuration.get("svn.branch.tags.processing")
                self.svn_look_cmd = configuration.get("svn.look.cmd.path")
                if not os.path.exists(self.svn_look_cmd):
                    self.svn_look_cmd = "svnlook"

                self.jch = JiraCommitHook(configuration)

                self.file_status = {
                    "D" : "DEL",
                    "U" : "MODIFY",
                    "A" : "ADD",
                    "M" : "MODIFY"
                }

            except ValueError, e:
                sys.stderr.write("{0}\n".format(e))
                sys.exit(1)
        else:
            sys.stderr.write("Config file ({0}) not exists!\n".format(config))
            sys.exit(1)

    def get_svn_change(self, repos, revision):
        """
        get_svn_change(). get scm change activity for given revision
        :param repos: Subversion repository path
        :param revision: Subversion revision
        :return: object
        """

        changeset = ScmActivity()
        changeset.changeId = revision        
        changeset.changeMessage = self.jch.command_output("{0} log -r {1} {2}".format(self.svn_look_cmd, revision, repos))
        changeset.changeAuthor = self.jch.command_output("{0} author -r {1} {2}".format(self.svn_look_cmd, revision, repos))
        changeset.changeDate = " ".join(self.jch.command_output("{0} date -r {1} {2}".format(self.svn_look_cmd, revision, repos)).split()[:2])

        changed_output = self.jch.command_output("{0} changed -r {1} {2}".format(self.svn_look_cmd, revision, repos))

        change_files = []
        change_tags = []
        change_branches = []

        for svn_file in changed_output.split("\n"):
            file_action, file_name = svn_file.strip().split(' ', 1)

            # change files
            if self.file_status.get(file_action):
                file_action = self.file_status.get(file_action)

            file_dict = {
                "fileName" : file_name,
                "fileAction" : file_action
            }
            change_files.append(file_dict)

            # change branches or tags
            if self.svn_branch_tags:
                svn_path_dir_names = os.path.normpath(file_name).split(os.path.sep)
                if file_name.__contains__("branches/"):
                    svn_branch_index = svn_path_dir_names.index("branches")
                    if svn_branch_index < len(svn_path_dir_names) - 1:
                        svn_branch_name = svn_path_dir_names[svn_branch_index + 1]
                        change_branches.append(svn_branch_name)
                elif file_name.__contains__("tags/"):
                    svn_tag_index = svn_path_dir_names.index("tags")
                    if svn_tag_index < len(svn_path_dir_names) - 1:
                        svn_tag_name = svn_path_dir_names[svn_tag_index + 1]
                        change_tags.append(svn_tag_name)

        changeset.changeFiles = change_files
        if self.svn_branch_tags:
            if len(change_branches) > 0:
                changeset.changeBranch = ",".join(set(change_branches))
            if len(change_tags) > 0:
                changeset.changeTag = ",".join(set(change_tags))

        return changeset

    def run(self, repos, revision):
        """
        run(). executes the jira update for the given change-set
        :param repos: Subversion repository path
        :param revision: Subversion revision
        :return: 0 or 1
        """

        svn_changeset = self.get_svn_change(repos, revision)

        if svn_changeset:
            matched_issue_keys = self.jch.pattern_validate(svn_changeset.changeMessage)

            # Preferred format: ChangeType_Repo Name e.g. svn_ccx
            svn_changeset.changeType = "{0}_{1}".format('svn', os.path.basename(repos).replace("-","_"))

            svn_changeset.changeLink = self.svn_server_web.format(os.path.basename(repos), revision)

            'print dumps(svn_changeset.__dict__, indent=4)'
            'print matched_issue_keys'

            if len(matched_issue_keys.keys()) > 0:
                res = self.jch.jira_update(svn_changeset, matched_issue_keys.keys(), 1)
                'self.jch.jira_update(p4_change, matched_issue_keys.keys(), 1)' # to update existing activity
                return res 

        return 0


def main():
    """
    main(). parses sys arguments for execution
    :param: None
    :return: None 
    """

    parser = argparse.ArgumentParser(description='SCM Activity GIT Post Receive Hook Execution Script')
    parser.add_argument("--config", help='Required config')
    parser.add_argument("--repos", help='Required repository', required=True)
    parser.add_argument("--rev", help='Required revision', required=True)

    args = parser.parse_args()

    if args.repos and args.rev:
        g = SvnPostCommitHook(args.config)
        res = g.run(args.repos, args.rev)
        if res != 0:
            sys.exit(1)
    else:
        sys.stderr.write("[usage] post-commit repos revision\n")
        sys.exit(1)
    
    sys.exit(0)


if __name__ == '__main__':
    main()
