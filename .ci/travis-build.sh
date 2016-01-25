#!/bin/sh
set -e

#if generator is Xcode
if [ "${TRAVIS_CMAKE_GENERATOR}" = Xcode ]; then
    xcbuild() { set -o pipefail && xcodebuild "$@" | xcpretty -c; }
    export -f xcbuild
    
    xcbuild -configuration ${TRAVIS_BUILD_TYPE}
else
    cmake --build . --config ${TRAVIS_BUILD_TYPE}
    # build two times: one for normal use and one to make sure that some project 
    # is not incorrectly using the installed headers instead of the build one 
    # see https://github.com/robotology/idyntree/issues/52 for more details
    (cd ./install/include && find . -type f -exec /bin/sh -c "> '{}'" ';')
    cmake --build . --config ${TRAVIS_BUILD_TYPE}
fi
