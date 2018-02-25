#!/bin/sh

set -e

#if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = linux -o -z "$TRAVIS_OS_NAME" ]; then
    sudo add-apt-repository ppa:octave/stable -y
    sudo add-apt-repository ppa:nschloe/eigen-backports -y
    sudo sh -c 'echo "deb http://www.icub.org/ubuntu trusty contrib/science" > /etc/apt/sources.list.d/icub.list'
    sudo apt-get update
    sudo apt-get -y --force-yes install -qq libboost-filesystem-dev libboost-system-dev libboost-thread-dev libtinyxml-dev libboost-iostreams-dev icub-common  valgrind liblua5.1-0-dev lua5.1 swig python-dev cmake libeigen3-dev liboctave-dev
    # On Ubuntu, make sure not to use openblas as blas backend, see https://github.com/robotology/idyntree/issues/307
    sudo apt-get install libatlas-base-dev
    sudo update-alternatives --set libblas.so.3  /usr/lib/atlas-base/atlas/libblas.so.3
elif [ "$TRAVIS_OS_NAME" = osx ]; then
    gem install xcpretty
    brew update &> /dev/null
    brew tap ros/deps
    source .ci/brew_install_or_upgrade_formula.sh
    # brew tap homebrew/versions #useful only if we need a particular version.
    brewInstallFormulas eigen boost ace pkg-config jpeg swig sqlite readline gsl tinyxml robotology/formulae/yarp urdfdom
fi
