#!/bin/bash
set -e

msg=`git log -1 --pretty=%B | xargs echo` # trimmed commit msg

if [[ "$msg" != Upgrade\ linux\ to\ v* ]] && [[ "$msg" != Upgrade\ osx\ to\ v* ]] ; then
	exit 0
fi

if [[ "$msg" == *\ linux\ * ]]; then
	if [[ "$TRAVIS_OS_NAME" != "linux" ]]; then
		exit 0
	fi

	vsn="${msg#Upgrade linux to v*}"
	sudo apt-get install gcc-multilib
	sudo apt-get install g++-multilib
elif [[ "$msg" == *\ osx\ * ]]; then
	if [[ "$TRAVIS_OS_NAME" != "osx" ]]; then
		exit 0
	fi

	vsn="${msg#Upgrade osx to v*}"
	brew update >/dev/null
	brew install gcc || brew outdated gcc || brew upgrade gcc
fi


git clone https://github.com/blitzrk/sublime_sassc ../sassc
pushd ../sassc >/dev/null

git checkout --quiet master

./build.sh -m32 "$vsn"
cp sassc st2_${TRAVIS_OS_NAME}_x32/
cp sassc st3_${TRAVIS_OS_NAME}_x32/
rm sassc

./build.sh -m64 "$vsn"
cp sassc st2_${TRAVIS_OS_NAME}_x64/
cp sassc st3_${TRAVIS_OS_NAME}_x64/
rm sassc

git config --global user.name "Travis CI"
git config --global user.email "builds@travis-ci.org"
git add .
git commit -m "Upgraded ${TRAVIS_OS_NAME} to v$vsn"
git push "https://${GH_TOKEN}@github.com/blitzrk/sublime_sassc.git" master

popd >/dev/null
