#!/bin/bash

git submodule init
git submodule update

(cd libsass && git pull origin master)
(cd sassc.git && git pull origin master)

BUILD="shared" make -C libsass -j5
SASS_LIBSASS_PATH="`pwd`/libsass" make -C sassc.git -j5

cp sassc.git/bin/sassc ./

echo -e "\n\nNow copy 'sassc' to the correct directories and commit.\n"
