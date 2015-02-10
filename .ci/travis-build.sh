#!/bin/sh
set -e

#if generator is Xcode
if [ "${TRAVIS_CMAKE_GENERATOR}" = Xcode ]; then
    xcbuild() { set -o pipefail && xcodebuild "$@" | xcpretty -c; }
    export -f xcbuild
    
    xcbuild -configuration ${TRAVIS_BUILD_TYPE}
else
    cmake --build . --config ${TRAVIS_BUILD_TYPE}
fi
