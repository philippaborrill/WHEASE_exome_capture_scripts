# How to use git

# Open git bash in windows

# move into Uauy cluster folder (is according to windows paths)
cd /Y

# move into folder where you want to initiate a git repository
cd /Y/WHEASE/exome_capture_analysis/scripts_used

# initiate git repo
git init

# add files to track with git 
git add *pl

# or for all files
git add *

# I made the settings so that git won't change line endings (don't to alter this again)
git config --global core.autocrlf false

# check status of files added
git status

# commit staged (added) files to git repository
git commit -m "initial scripts added"

# On github website create a repository to use to push this repository to
# e.g. I made WHEASE_exome_capture_scripts
# Copy the URL from github (click on clone/download then the clipboard)

# add this URL as the origin
git remote add origin https://github.com/philippaborrill/WHEASE_exome_capture_scripts.git

# check the remote is correct
git remote -v

# push to origin
git push origin master

## NB if you created a readme in the github website this step won't work first time - instead you need to push via GitHub desktop or don't add any files to the repo until you have pulled it down from github website
