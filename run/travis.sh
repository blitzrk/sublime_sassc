#!/bin/bash
set -e

msg=`git log -1 --pretty=%B | xargs echo` # trimmed commit msg

if [[ "$msg" != Upgrade\ Linux\ to\ v* ]]; then
	exit 0
else
	vsn="${msg#Upgrade Linux to v*}"
fi

sudo apt-get install gcc-multilib
sudo apt-get install g++-multilib

git clone https://github.com/blitzrk/sublime_sassc ../sassc
pushd ../sassc

git checkout --quiet master

./build.sh -m32 "$vsn"
cp sassc st2_linux_x32/
cp sassc st3_linux_x32/
rm sassc

./build.sh -m64 "$vsn"
cp sassc st2_linux_x64/
cp sassc st3_linux_x64/
rm sassc

git config --global user.name "Travis CI"
git config --global user.email "builds@travis-ci.org"
git add .
git commit -m "Upgraded Linux to v$vsn"
git push "https://${GH_TOKEN}@github.com/blitzrk/sublime_sassc.git" master

popd
