# git-undelete-all.sh

Bash script to undelete everything that is easy to undelete in a Git repository.

    $ bash git-undelete-all.sh -h
    Usage git-undelete-all [OPTION...]

    -h  help: print this usage information
    -s  silent: do not print output
    -v  verbose: print every file recovered
    
This script can come in handy when evaluating the history of a repository.

### Usage

Copy the script into the repository that you want to undelete files in and run:

    bash git-undelete-all.sh

It should output something like:

    1 files restored in 0 seconds

If you run with "-v" the script will print the filename of each undeleted file on a separate line.

### How it works

It is automating the following process (where "undelete.sh" is a deleted file):

1) List the files that are deleted from the Github repository:

      `git log --pretty=format: --name-only --diff-filter=D | sort -u`

2) Which gives you the filenames of the deleted files:

      `undelete.sh`

3) Then get the hash of the commit in which the file is deleted:

      `git rev-list -n 1 HEAD -- undelete.sh`

4) Which gives you the hash of the undeletion:

      `ae85c23372a8a45b788ed857800b3b424b1c15f8`

5) Now you can checkout the version of the file before the deletion:

      `git checkout ae85c23372a8a45b788ed857800b3b424b1c15f8^ -- undelete.sh`

And doing that for every file in the list that is retrieved in step 2.
