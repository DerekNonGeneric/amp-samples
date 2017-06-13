#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Save essential config vars
exec 3< <(node ./tasks/output-config.js);
lines=();
while read -r; do lines+=("$REPLY"); done <&3;
exec 3<&-;

DEST_DIR="${lines[1]}"
SOURCE_BRANCH="${lines[0]}"
TARGET_BRANCH="gh-pages"
REPO_NAME="${lines[3]}"

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

# Clone the existing gh-pages for this repo into ${DEST_DIR}/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deply)
git clone $REPO ${DEST_DIR}/${REPO_NAME}
cd ${DEST_DIR}/${REPO_NAME}
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ../..

# Clean out existing contents
rm -rf ${DEST_DIR}/**/* || exit 0

# Run our compile script
gulp dist

# Move the git repository to the directory to deploy
# mv ${DEST_DIR}/.git ${DEST_DIR}/${REPO_NAME}/.git

# Now let's go have some fun with the cloned repo
cd ${DEST_DIR}/${REPO_NAME}
git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# Commit the "changes", i.e. the new version
# The delta will show diffs between new and old versions
git add -A .
git commit --allow-empty -m "Deploy to GitHub Pages: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ../../deploy_key.enc -out ../../deploy_key -d
chmod 600 ../../deploy_key
eval `ssh-agent -s`
ssh-add ../../deploy_key

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH
