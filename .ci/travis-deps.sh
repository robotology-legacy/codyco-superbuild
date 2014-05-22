#!/bin/sh

set -e

#if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = linux -o -z "$TRAVIS_OS_NAME" ]; then
    sudo sh -c 'echo "deb http://www.icub.org/ubuntu precise contrib/science" > /etc/apt/sources.list.d/icub.list'
    sudo add-apt-repository -y ppa:kalakris/cmake
    sudo apt-get update
    sudo apt-get install -qq libboost-system-dev libboost-thread-dev libtinyxml-dev
    sudo apt-get --force-yes install icub
    sudo apt-get install cmake
    #eigen 3.2 support
    hg clone https://bitbucket.org/eigen/eigen/
    cd eigen
    hg checkout 3.2.0
    mkdir build
    cd build
    cmake ..
    make
    sudo make install
    cd ../..
elif [ "$TRAVIS_OS_NAME" = osx ]; then
    brew tap homebrew/versions
    brew install cmake
    brew install eigen
    brew install boost
    brew install ace
fi
