#!/bin/bash

git submodule init
git submodule update

(
	cd libsass
	git pull origin master
	TAG=`git log --date-order --tags --simplify-by-decoration --pretty=format:"%d" | perl -ne 'print if s/.+?tag: v?([0-9.]+)[,\)].*$/\1/' | head -n 1`
	git checkout tags/$TAG
)
(
	cd sassc.git
	git pull origin master
	TAG=`git log --date-order --tags --simplify-by-decoration --pretty=format:"%d" | perl -ne 'print if s/.+?tag: v?([0-9.]+)[,\)].*$/\1/' | head -n 1`
	git checkout tags/$TAG
)

BUILD="shared" make -C libsass -j5
SASS_LIBSASS_PATH="`pwd`/libsass" make -C sassc.git -j5

cp sassc.git/bin/sassc ./

echo -e "\n\nNow copy 'sassc' to the correct directories and commit.\n"
