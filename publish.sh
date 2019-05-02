#!/bin/sh

# publish.sh
# Generates site using Hugo compiler then pushes it to gh-pages branch
# The website pulls from our gh-pages branch to build itself.
# Christopher Choy 2019

DIR=/path/to/your/local/github/repo/folder/

cd $DIR/

# Check for uncommitted changes to the repository
if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

# Pull the gh-pages branch
git pull

# Delete the old publication of the website
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

# Checking out gh-pages branch into public and clean it
git worktree add -B gh-pages public origin/gh-pages
rm -rf public/*

# Generate the website
hugo

# Update the gh-pages branch with new website content
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

# Push the updated branch to github
git push origin gh-pages

echo "\n\nPublish Complete. You must update the Custom Domain field in the Repo Settings:"
