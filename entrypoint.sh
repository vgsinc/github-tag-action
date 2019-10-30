#!/bin/bash

function update_version() {
    str="$1"
    IFS="." read -ra PARTS <<< "${str}"
    updated="${PARTS[0]}.$((PARTS[1]+1))"
}

#config
semver_bump=${BUMP:-build}
with_v=${WITH_V:-false}
skip_no_changes=${SKIP_NO_CHANGES:-true}

echo "--------------------------------------------------------"
echo "Semver Bump: ${semver_bump}"
echo "Prefix: ${prefix_v}"
echo "Skip: ${skip_no_changes}"
echo "--------------------------------------------------------"

# get latest tag
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
tag_commit=$(git rev-list -n 1 $tag)

# get current commit hash for tag
commit=$(git rev-parse HEAD)

if [ $skip_no_changes == "true" -a "$tag_commit" == "$commit" ]; then
    echo "No new commits since previous tag. Skipping..."
    exit 0
fi

# TODO: If not tag is found, need to fail.
# if there are none, start tags at 0.0.0
if [ -z "$tag" ]
then
    tag=0.0.0
fi

echo "==> Found Tag: ${tag}"

# TODO: This part needs to be changed for the different bump levels...

case "$semver_bump" in
    major ) new=$(semver bump major $tag);;
    minor ) new=$(semver bump minor $tag);;
    patch ) new=$(semver bump patch $tag);;
    build )
        current=$(semver get build $tag)
        updated=""
        update_version "${current}"
        new=$(semver bump build $updated $tag)
        ;;
    #* ) new=$(semver bump `echo $default_semvar_bump` $tag);; # TODO: need to exit
esac

# prefix with 'v'
if [ with_v == "true" ]
then
    new="v$new"
fi

echo $new

# set output
echo ::set-output name=new-tag::$new

# push new tag ref to github
dt=$(date '+%Y-%m-%dT%H:%M:%SZ')
full_name=$GITHUB_REPOSITORY
#git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')
git_refs_url="https://api.github.com/repos/$REPO/git/refs" # Schedule triggers don't have this property.

echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"
cat $GITHUB_EVENT_PATH
echo "--------------------------------------------------------------------"
echo "--------------------------------------------------------------------"


echo "$dt: **pushing tag $new to repo $full_name"
echo "Git Ref URL: $git_refs_url"

curl -s -X POST $git_refs_url \
-H "Authorization: token $GITHUB_TOKEN" \
-d @- << EOF

{
  "ref": "refs/tags/$new",
  "sha": "$commit"
}
EOF
