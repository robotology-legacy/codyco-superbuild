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
###CMake
CMake is the multiplatform build system used by CoDyCo software. 

**The minimum version of CMake required by CoDyCo software is 2.8.11**

On Windows and OS X you can install it by downloading [the official binaries](http://www.cmake.org/cmake/resources/software.html), 
while on Linux you can install it using your package manager.


###Eigen 
Eigen is a C++ matrix library. 

**The minimum version of Eigen required by CoDyCo is 3.2.0**


####Windows 
On Windows you can install Eigen from source code available from the [Eigen official website](http://eigen.tuxfamily.org).
Eigen is also available as a [NuGet package](https://www.nuget.org/packages/Eigen/)/

####OS X
On OS X you can install Eigen using `brew`:
``
brew install eigen
``
####Linux
#####Debian/Ubuntu
On Debian/Ebuntu you can install Eigen using the `libeigen3-dev` package:
```
sudo apt-get install libeigen3-dev
```

###YARP/ICUB
You can follow the instructions on: http://wiki.icub.org/wiki/ICub_Software_Installation . 

**The minimum version of YARP required by CoDyCo is 2.3.62**

**The minimum version of ICUB required by CoDyCo is 1.1.14**

Installation
------------
This is a meta repository (so-called "superbuild") that uses [YCM](https://github.com/robotology/ycm) to compile CoDyCo software.
YCM will take care of compiling all the missing dependencies, except the one that you should not install from source code (so-called "system dependencies"). 

We provide different instructions on how to install codyco-superbuild, depending on your operating system:
* [**Windows**](#Windows): use the superbuild with Microsoft Visual Studio
* [**OS X**](#OS-X): use the superbuild with XCode or make
* [**Linux**](#Linux): use the superbuild with make 

##Windows


##OS X


##Linux 
###System Dependencies 
On Debian based systems (as Ubuntu) you can install CMake and Eigen using `apt-get`:
```
sudo apt-get install libeigen3-dev cmake
```

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
