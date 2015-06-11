#!/bin/sh

set -e

#if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = linux -o -z "$TRAVIS_OS_NAME" ]; then
    sudo sh -c 'echo "deb http://www.icub.org/ubuntu precise contrib/science" > /etc/apt/sources.list.d/icub.list'
    sudo add-apt-repository -y ppa:robotology/ppa
    sudo add-apt-repository -y ppa:kubuntu-ppa/backports
    sudo apt-get update
    sudo apt-get install -qq libboost-system-dev libboost-thread-dev libtinyxml-dev
    #if [ "$CODYCO_YARP_FROM_SUPERBUILD" = True ]; then
        echo -e "codyco-superbuild travis testing: installing yarp from superbuild\n"
        sudo apt-get --force-yes install icub-common
    #else
        #echo -e "codyco-superbuild travis testing: installing yarp from deb packages\n"
        #sudo apt-get --force-yes install icub
    #fi
    sudo apt-get install cmake
    if [ "k$CODYCO_WITH_OLD_EIGEN" = "ktrue" ]; then
        sudo apt-get install libeigen3-dev
    else
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
    fi
elif [ "$TRAVIS_OS_NAME" = osx ]; then
    gem install xcpretty
    brew update &> /dev/null
    brew tap homebrew/x11
    source .ci/brew_install_or_upgrade_formula.sh    
    # brew tap homebrew/versions #useful only if we need a particular version.
    brewInstallFormulas eigen boost ace pkg-config gtk+ jpeg gtkmm sqlite readline gsl libglademm tinyxml
    brew install yarp --HEAD
fi
