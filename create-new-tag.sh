set -e
LAST_HABSPEAKER_RELEASE=$(curl -s -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/GiviMAD/openhab-addons/releases | jq -r '.[] | .tag_name' | grep habspeaker-  | head -n 1)
echo "last habspeaker release tag is $LAST_HABSPEAKER_RELEASE"
TAG_NAME=${LAST_HABSPEAKER_RELEASE#"habspeaker-"}
RELEASE_TAG_NAME=release_${TAG_NAME}
PREV_TAG=$(curl -s -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/habspeaker/habspeaker-builds/releases | jq -r '.[] | .tag_name' | grep $RELEASE_TAG_NAME | head -n 1)
if [ -z "$PREV_TAG" ]; then
    echo "creating tag $TAG_NAME"
    git tag $TAG_NAME
    git push --tags
else
    echo "release for version $TAG_NAME already exists"
    exit 1
fi
