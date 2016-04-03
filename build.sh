#!/bin/bash

pCFLAGS=$CFLAGS
pCXXFLAGS=$CXXFLAGS
pLDFLAGS=$LDFLAGS

if [ "$1" == "-m32" ]; then export CFLAGS='-m32'; else unset CFLAGS; fi
if [ "$1" == "-m32" ]; then export CXXFLAGS='-m32'; else unset CXXFLAGS; fi
if [ "$1" == "-m32" ]; then export LDFLAGS='-m32'; else unset LDFLAGS; fi

if [ -n "$2" ]; then
	vsn=$2
else
	vsn=`git log --date-order --tags --simplify-by-decoration --pretty=format:"%d" \
		| perl -ne 'print if s/.+?tag: v?([0-9.]+)[,\)].*$/\1/' | head -n 1`
fi

git submodule --quiet deinit -f .
git submodule --quiet init
git submodule --quiet update
git submodule --quiet foreach "git checkout --quiet tags/$vsn"

echo Building v$vsn $1

(
	BUILD="shared" make -C libsass -j5 >/dev/null && echo "libsass build succeeded" &&
	SASS_LIBSASS_PATH="`pwd`/libsass" make -C sassc.git -j5 >/dev/null && echo "sassc build succeeded" &&

	cp sassc.git/bin/sassc ./ &&

	echo -e "\nNow copy 'sassc' to the correct directories and commit.\n"
)

if [ -z "$pCFLAGS" ]; then unset CFLAGS; else export CFLAGS=$pCFLAGS; fi
if [ -z "$pCXXFLAGS" ]; then unset CXXFLAGS; else export CXXFLAGS=$pCXXFLAGS; fi
if [ -z "$pLDFLAGS" ]; then unset LDFLAGS; else export LDFLAGS=$pLDFLAGS; fi
