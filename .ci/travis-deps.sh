#!/bin/sh

set -e

#if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = linux -o -z "$TRAVIS_OS_NAME" ]; then
    sudo sh -c 'echo "deb http://www.icub.org/ubuntu trusty contrib/science" > /etc/apt/sources.list.d/icub.list'
    sudo apt-get update
    sudo apt-get -y --force-yes install -qq libboost-filesystem-dev libboost-system-dev libboost-thread-dev libtinyxml-dev libboost-iostreams-dev icub-common  valgrind liblua5.1-0-dev lua5.1 swig python-dev cmake libeigen3-dev
elif [ "$TRAVIS_OS_NAME" = osx ]; then
    gem install xcpretty
    brew update &> /dev/null
    brew tap homebrew/x11
    source .ci/brew_install_or_upgrade_formula.sh
    # brew tap homebrew/versions #useful only if we need a particular version.
    brewInstallFormulas eigen boost ace pkg-config gtk+ jpeg gtkmm swig sqlite readline gsl libglademm tinyxml lua
    brew install yarp --HEAD
fi
