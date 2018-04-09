#!/usr/bin/env bash

set -xe
HASH=$(git describe --tags)
TAG=${TRAVIS_BRANCH:-latest}

build() {
   LAUNCHER_HASH=$(curl https://api.github.com/repos/flokkr/launcher/commits/master | jq -r '.sha')
	echo "Using launcher $LAUNCHER_HASH"
	docker build -t flokkr/base:$TAG --build-arg LAUNCHER_HASH=$LAUNCHER_HASH --label io.github.flokkr.base.version=$HASH --label io.github.flokkr.launcher.version=$LAUNCHER_HASH .
}

deploy() {
	docker push flokkr/base:${TAG}
}


while getopts ":t:" opt; do
  case $opt in
    t)
      export TAG=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


shift $(($OPTIND -1))
eval $*
