#!/bin/bash

git submodule --quiet init
git submodule --quiet update
git submodule foreach "git checkout tags/\`git log --date-order --tags --simplify-by-decoration --pretty=format:"%d" | perl -ne 'print if s/.+?tag: v?([0-9.]+)[,\)].*$/\1/' | head -n 1\`"

BUILD="shared" make -C libsass -j5 >/dev/null && echo "libsass build succeeded"
SASS_LIBSASS_PATH="`pwd`/libsass" make -C sassc.git -j5 >/dev/null && echo "sassc build succeeded"

cp sassc.git/bin/sassc ./

echo -e "\nNow copy 'sassc' to the correct directories and commit.\n"
