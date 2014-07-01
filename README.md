CoDyCo Project Superbuild
---------------
| Linux/OS X | Windows |
|:----------:|:--------|
| [![Build Status](https://travis-ci.org/robotology-playground/codyco-superbuild.png?branch=master)](https://travis-ci.org/robotology-playground/codyco-superbuild) | [![Build status](https://ci.appveyor.com/api/projects/status/61nm80pingh680x5)](https://ci.appveyor.com/project/traversaro/codyco-superbuild-112) |
The CoDyCo project is a four-years long project that started in March 2013. At the end of each year a scenario will be used to validate on the iCub the theoretical advances of the project.

More info at http://codyco.eu/

Code documentation automatically generated: http://wiki.icub.org/codyco/dox/html/index.html



System Dependencies
-------------------
**CMake 2.8.11 or greater**

CMake is the multiplatform build system used by CoDyCo software. 


**Eigen 3.2.0 or greater**

Eigen is a C++ matrix library. 


**YARP 2.3.62 or greater**

YARP is a library for communication and device interfaces in robots.


**ICUB 1.1.14 or greater** 

ICUB is a collection of software developed by the iCub humanoid robot community.

Installation
------------
This is a meta repository (so-called "superbuild") that uses [YCM](https://github.com/robotology/ycm) to compile CoDyCo software. 
A YCM Superbuild is a CMake project whose only goal is to download and build several other projects. You can read more about the superbuild concept in [YCM documentation](http://robotology.github.io/ycm/gh-pages/master/manual/ycm-superbuild.7.html).

**WARNING: If you still have the old codyco repository installed, you should uninstall it (for example using `sudo make uninstall` in Linux) before proceeding with `codyco-superbuild` installation.**


We provide different instructions on how to install codyco-superbuild, depending on your operating system:
* [**Windows**](#Windows): use the superbuild with Microsoft Visual Studio
* [**OS X**](#OS-X): use the superbuild with XCode or make
* [**Linux**](#Linux): use the superbuild with make 

##Windows
**WARNING: YCM based superbuild is currently broken in Windows, due to a [YCM upstream bug](https://github.com/robotology/ycm/issues/16)**

###System Dependencies 
To install CMake you can use the official installer available at http://www.cmake.org/cmake/resources/software.html .

You can install Eigen from source code available from the [Eigen official website](http://eigen.tuxfamily.org).
Eigen is also available as a [NuGet package](https://www.nuget.org/packages/Eigen/).

For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/ICub_Software_Installation).

###Superbuild
You can clone the superbuild repository as any other git repository, and generate the Visual Studio solution
using the CMake gui. Then you open the generated solution with Visual Studio and build the target `all`. 
Visual Studio will then download, build and install in a local directory all the CoDyCo software and its dependencies.

###Configure your enviroment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries and libraries, you should update the necessary enviroment variables.

Set the environment variable CODYCO\_SUPERBUILD\_DIR so that it points to the  directory where you clone the codyco-superbuild repository.

Append $CODYCO\_SUPERBUILD\_DIR/build/install/bin to your PATH.

##OS X
**WARNING: YCM based superbuild is currently broken with XCode generators, please use the make generator also in OS X.**

###System Dependencies 
To install Eigen and CMake, it is possible to use [Homebrew](http://brew.sh/):
```
brew install eigen cmake
```

For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/ICub_Software_Installation).

###Superbuild
Finally, after installing all the system dependencies, it is possible to install CoDyCo software using the YCM superbuild:
```bash
git clone https://github.com/robotology-playground/codyco-superbuild.git
cd codyco-superbuild
mkdir build
cd build
ccmake ../
make
```
###Configure your enviroment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries and libraries, you should update the `PATH` and `LD_CONFIG_PATH` enviroment variables.

An easy way is to add this lines to the '.bashrc` file in your home directory:
```
CODYCO_SUPERBUILD_ROOT=/directory/where/you/downloaded/codyco-superbuild
export PATH=$CODYCO_SUPERBUILD_ROOT/build/install/bin:$PATH
export DYLD_LIBRARY_PATH=$CODYCO_SUPERBUILD_ROOT/build/install/lib:$DYLD_LIBRARY_PATH
```
To use the updated `.bashrc` in your terminal you should run the following command:
```bash
user@host:~$ source ~/.bashrc
```
It may also be necessary to update the cache of the dynamic linker:
```bash
user@host:~$ sudo ldconfig
```

##Linux 
###System Dependencies 
On Debian based systems (as Ubuntu) you can install CMake and Eigen using `apt-get`:
```
sudo apt-get install libeigen3-dev cmake
```
The packages provided in the official distro repositories work out of the box for **Ubuntu 14.04** (`trusty`), **Ubuntu 13.10** (`saucy`) and **Debian 8** (`jessie`).
For older distros the included CMake and Eigen are too old, and is necessary to find a way to install them from an alternative
source.. 
For example in **Debian 7** (`wheezy`) it is sufficient to [enable the `wheezy-backports` repository](http://backports.debian.org/Instructions/) to get recent versions of CMake and Eigen.

For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/ICub_Software_Installation).

###Superbuild
Finally, after installing all the system dependencies, it is possible to install CoDyCo software using the YCM superbuild:
```bash
git clone https://github.com/robotology-playground/codyco-superbuild.git
cd codyco-superbuild
mkdir build
cd build
ccmake ../
make
```
###Configure your enviroment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries and libraries, you should update the `PATH` and `LD_CONFIG_PATH` enviroment variables.

An easy way is to add this lines to the '.bashrc` file in your home directory:
```
CODYCO_SUPERBUILD_ROOT=/directory/where/you/downloaded/codyco-superbuild
export PATH=$CODYCO_SUPERBUILD_ROOT/build/install/bin:$PATH
export LD_LIBRARY_PATH=$CODYCO_SUPERBUILD_ROOT/build/install/lib:$LD_LIBRARY_PATH
```
To use the updated `.bashrc` in your terminal you should run the following command:
```bash
user@host:~$ source ~/.bashrc
```
If may also be necessary to updates the cache of the dynamic linker:
```bash
user@host:~$ sudo ldconfig
```
