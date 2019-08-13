# git-undelete-all.sh

Script to undelete everything that is easy to undelete in the repo.

    $ bash git-undelete-all.sh -h
    Usage git-undelete-all [OPTION...]

    -h  help: print this usage information
    -s  silent: do not print output
    -v  verbose: print every file recovered
    
### Usage

Copy the script into the repository that you want to investigate and run:

    bash git-undelete-all.sh

It should output:

    $ bash git-undelete-all.sh 
    1 files restored in 0 seconds

If you run with "-v" or "-s" the script will give more or no output.

### How it works

It is automating:

1) List the files that are deleted from the Github repository:

    git log --pretty=format: --name-only --diff-filter=D | sort -u

2) Then get the hash of the commit in which a file is deleted:

    git rev-list -n 1 HEAD -- some_deleted_file.txt

3) Which gives you the hash of the undeletion:

    f885b71ee65611bbae0989e37cb0b2def1947c38

4) Now you can checkout the version of the file before the deletion:

    git checkout f885b71ee65611bbae0989e37cb0b2def1947c38^ -- some_deleted_file.txt

And doing that for every file in the list that is retrieved in step 1.
