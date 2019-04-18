#!/bin/bash
# make executable with <chmod +x git.sh>

get_repo_user()
{
    local username=$(git config user.name);
    local useremail=$(git config user.email);
    echo "User => ${username} <${useremail}>"
}

# USAGE: source git.sh; change_repo_user <username> <email>
change_repo_user() {
    echo "Old"; get_repo_user; echo;
    git config user.name "$1";
    git config user.email "$2";
    echo "New"; get_repo_user;
}

# USAGE: source git.sh; change_commit_author_user <username> <email>
# THIS WILL REWRITE HISTORY, DONT USE ON PUBLIC REPO
change_commit_author_user() {
    git filter-branch --env-filter '
        NAME="'$1'"
        EMAIL="'$2'"

        if [ "$GIT_COMMITTER_EMAIL" != "$EMAIL" ]
        then
            export GIT_COMMITTER_NAME="$NAME"
            export GIT_COMMITTER_EMAIL="$EMAIL"
        fi
        if [ "$GIT_AUTHOR_EMAIL" != "$EMAIL" ]
        then
            export GIT_AUTHOR_NAME="$NAME"
            export GIT_AUTHOR_EMAIL="$EMAIL"
        fi
    ' --tag-name-filter cat -- --branches --tags;
    echo "Done!";
}