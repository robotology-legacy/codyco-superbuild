CoDyCo Project Superbuild
---------------
| Linux/OS X | Windows |
|:----------:|:--------:|
| [![Build Status](https://travis-ci.org/robotology/codyco-superbuild.png?branch=master)](https://travis-ci.org/robotology/codyco-superbuild) | [![Build status](https://ci.appveyor.com/api/projects/status/hurs7dtqsstsebpm/branch/master?svg=true)](https://ci.appveyor.com/project/robotology/codyco-superbuild/branch/master) | 


The CoDyCo project is a four-years long project that started in March 2013. At the end of each year a scenario will be used to validate on the iCub the theoretical advances of the project.

More info at http://codyco.eu/

Code documentation automatically generated: http://wiki.icub.org/codyco/dox/html/index.html

This is a meta repository (so-called "superbuild") that uses [CMake](https://cmake.org/) and [YCM](https://github.com/robotology/ycm) to automatically download and compile CoDyCo software.
[CMake](https://cmake.org/) is an open-source, cross-platform family of tools designed to build, test and package software. 
A YCM Superbuild is a CMake project whose only goal is to download and build several other projects. You can read more about the superbuild concept in [YCM documentation](http://robotology.github.io/ycm/gh-pages/master/manual/ycm-superbuild.7.html).

Table of Contents
=================
  * [Superbuild structure](#superbuild-structure)
  * [Installation](#installation)
    * [Linux](#linux)
    * [OS X](#os-x)
    * [Windows](#windows)
  * [Update](#update)
  * [MATLAB software](#matlab-software)

Superbuild structure
====================

codyco-superbuild will download and build a number of projects, divided in components.
For each project, the repository will be downloaded in the `component/project` subdirectory
of the superbuild root. The build directory for a given project will be instead the `component/project` subdirectory
of the superbuild build directory.

###`external`

The `external` component contains software not developed inside the CoDyCo consortium, but that is a dependency of CoDyCo software.

###`libraries`

The `libraries` component contains librares developed by the CoDyCo consortium, that could be used also by external software.

The projects downloaded in the `libraries` component are:

* [`codyco-commons`](https://github.com/robotology-playground/codyco-commons) : A collection of functions and utilities used in the other projects 
* [`idyntree`](https://github.com/robotology/idyntree) : YARP-based Floating Base Robot Dynamics Library
* [`paramHelp`](https://github.com/robotology-playground/paramHelp) : Library for simplifying the management of the parameters of YARP modules
* [`wholebodyinterface`](https://github.com/robotology-playground/wholebodyinterface) : C++ Interfaces to sensor measurements, state estimations, kinematic/dynamic model and actuators for a floating base robot 
* [`yarp-wholebodyinterface`](https://github.com/robotology-playground/yarp-wholebodyinterface) : Implementation of the wholeBodyInterface for YARP robots 
* `orocosBFLBerdy`: Fork of the Bayesian Filtering Library [Orocos-BFL](http://www.orocos.org/bfl). *Early stage. Currently used and tested only for the quaternionEKF module and basic Kalman Filtering*
* [`EigenLgsm`](https://github.com/ocra-recipes/eigen_lgsm) : Lie group solid mechanics header library for Eigen. 
* [`ocra-recipes`](https://github.com/ocra-recipes/ocra-recipes) : Optimization based Control for Robotics Applications. A set of libraries designed to efficiently formulate robot control problems as a convex optimization problems. 

###`main`

The `main` component contains executable software developed by the CoDyCo consortium, for example YARP modules,
Simulink models or Lua scripts.

The projects downloaded in the `main` component are:

* [`WB-Toolbox 2.0`](https://github.com/robotology/WB-Toolbox) : Simulink Toolbox for rapid prototyping of Whole Body Robot Controllers.
* [`codyco-modules`](https://github.com/robotology/codyco-modules) : YARP modules and controllers developed within the European Project CoDyCo.
* [`ocra-wbi-plugins`](https://github.com/ocra-recipes/ocra-wbi-plugins) : Interface between the whole-body controller libraries (`ocra-recipes`) developed at ISIR and WBI. To compile these libraries and modules, enable the option: `CODYCO_BUILD_OCRA_MODULES : ON`.

Installation
============
**The [`gazebo-yarp-plugins`](https://github.com/robotology/gazebo_yarp_plugins), that are usually used for testing CoDyCo software simulating the iCub in Gazebo, are not installed by the `codyco-superbuild`. If you want to simulate the iCub in Gazebo you have to follow the instruction in [gazebo-yarp-plugins README](https://github.com/robotology/gazebo_yarp_plugins).**

We provide different instructions on how to install codyco-superbuild, depending on your operating system:
* [**Windows**](#windows): use the superbuild with Microsoft Visual Studio
* [**OS X**](#os-x): use the superbuild with Xcode or GNU make
* [**Linux**](#linux): use the superbuild with make

Complete documentation on [YCM documentation](http://robotology.github.io/ycm/gh-pages/master/manual/ycm-superbuild.7.html)

##Linux
###System Dependencies
On Debian based systems (as Ubuntu) you can install the C++ toolchain, Git, CMake and Eigen (and other dependencies necessary for the codyco-superbuild) using `apt-get`:
```
sudo apt-get install libeigen3-dev build-essential cmake cmake-curses-gui libboost-system-dev libboost-filesystem-dev libboost-thread-dev libtinyxml-dev libace-dev libgtkmm-2.4-dev libglademm-2.4-dev libgsl0-dev libcv-dev libhighgui-dev libcvaux-dev libode-dev liblua5.1-dev lua5.1 git swig
```
The packages provided in the official distro repositories work out of the box for **Ubuntu 14.04** (`trusty`), **Ubuntu 13.10** (`saucy`) and **Debian 8** (`jessie`).
For older distros the included CMake and Eigen are too old, and is necessary to find a way to install them from an alternative
source:
* In **Debian 7** (`wheezy`) it is sufficient to [enable the `wheezy-backports` repository](http://backports.debian.org/Instructions/) and install the recent versions of CMake and Eigen provided in it:
~~~
sudo apt-get -t wheezy-backports install cmake libeigen3-dev
~~~
* In **Ubuntu 12.04** (`precise`) a [PPA is available to easily install CMake 2.8.12](https://launchpad.net/~robotology/+archive/ubuntu/ppa). To install a recent version of Eigen the easiest solution is [to get Eigen from source](http://eigen.tuxfamily.org/index.php?title=Main_Page#Download).

#### YARP and iCub software
For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/Linux:Installation_from_sources). Please note that at the moment
the codyco-superbuild only supports YARP and ICUB installed from sources.

##### orocos-bfl-berdy
**If you don't know what orocos-bfl-berdy is, it is safe for you to skip this section**

When enabling the flag `CODYCO_USES_OROCOS_BFL_BERDY`, the library [Orocos-BFL-BERDY](https://github.com/jeljaik/orocos-bfl-berdy) is compiled and modules such as `quaternionEKF` enabled in `codyco-modules`. If you want to use the latter, besides Orocos-BFL-BERDY you will also need to set the environmental variable `PKG_CONFIG_PATH` as:
`export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$CODYCO_SUPERBUILD_ROOT/build/install/lib/pkgconfig/`
And as an additional dependency of `codyco-superbuild` you will also have: `libboost-iostreams-dev`.

###Superbuild
If you didn't already configured your git, you have to set your name and email to sign your commits:
```
git config --global user.name FirstName LastName
git config --global user.email user@email.domain
```
Finally it is possible to install CoDyCo software using the YCM superbuild:
```bash
git clone https://github.com/robotology/codyco-superbuild.git
cd codyco-superbuild
mkdir build
cd build
ccmake ../
make
```
###Configure your environment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries and libraries, you should update the `PATH` and `LD_CONFIG_PATH` environment variables.

An easy way is to add this lines to the '.bashrc` file in your home directory:
```
export CODYCO_SUPERBUILD_ROOT=/directory/where/you/downloaded/codyco-superbuild
export PATH=$PATH:$CODYCO_SUPERBUILD_ROOT/build/install/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CODYCO_SUPERBUILD_ROOT/build/install/lib
export YARP_DATA_DIRS=$YARP_DATA_DIRS:$CODYCO_SUPERBUILD_ROOT/build/install/share/codyco
```
To use the updated `.bashrc` in your terminal you should run the following command:
```bash
user@host:~$ source ~/.bashrc
```
If may also be necessary to updates the cache of the dynamic linker:
```bash
user@host:~$ sudo ldconfig
```

##OS X

###System Dependencies
To install Eigen and CMake, it is possible to use [Homebrew](http://brew.sh/):
```
brew install eigen cmake boost tinyxml swig
```

For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/ICub_Software_Installation).

###Superbuild
If you didn't already configured your git, you have to set your name and email to sign your commits:
```
git config --global user.name FirstName LastName
git config --global user.email user@email.domain
```
Finally it is possible to install CoDyCo software using the YCM superbuild:
```bash
git clone https://github.com/robotology/codyco-superbuild.git
cd codyco-superbuild
mkdir build
cd build
```
To use GNU Makefile generators:
```bash
cmake ../
make
```
To use Xcode project generators
```bash
cmake ../ -G Xcode
xcodebuild -configuration Release
```

###Configure your environment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries you should update the `PATH` environment variables.

An easy way is to add these lines to the `.bashrc` or `.bash_profile` file in your home directory:
```bash
CODYCO_SUPERBUILD_ROOT=/directory/where/you/downloaded/codyco-superbuild
export PATH=$PATH:$CODYCO_SUPERBUILD_ROOT/build/install/bin
export YARP_DATA_DIRS=$YARP_DATA_DIRS:$CODYCO_SUPERBUILD_ROOT/build/install/share/codyco
```

Most of the modules in the codyco-superbuild are correctly configured to automatically find the libraries.
If you create a new application or library that need to be linked to codyco-superbuild libraries (or if you are having issues with the dynamic loader) add also the following line to your `.bashrc` or `.bash_profile`.

```bash
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$CODYCO_SUPERBUILD_ROOT/build/install/lib
```

To use the updated `.bashrc` in your terminal you should run the following command:
```bash
user@host:~$ source ~/.bashrc
```
or for the `.bash_profile` file
```bash
user@host:~$ source ~/.bash_profile
```
or simply open a new terminal.

##Windows

### Disclaimer
While the software developed in the CoDyCo project is [tested to be compatible with Windows](https://ci.appveyor.com/project/robotology/codyco-superbuild/branch/master), 
the Gazebo simulator that we use as a simulation platform [does not support Windows](https://github.com/robotology/gazebo-yarp-plugins/issues/74). 
For this reason if you plan to do use the CoDyCo software with the Gazebo simulator, 
for the time being it is easier for you to use Linux or OS X. 

###System Dependencies
Most of the CoDyCo software is developed using the C/C++ language. For this reason, you should have Visual Studio installed on your computer to build it. In particular we install some dependencies of our software we rely on the binary installers
provided by [the official iCub software](http://wiki.icub.org/wiki/ICub_Software_Installation). As this binaries are still not available for Visual Studio 2015 (or 64 bit, at least for iCub), we recommend to use Visual Studio 2013 32bit to compile the CoDyCo software. 

You will also need some additional software, as listed afterwards.
Some of this software can be easily installed using [Chocolatey](https://chocolatey.org), a tool to simplify software installation on Windows.

####Git
Most of the CoDyCo software is hosted on Git repositories, so you will need Git to download them.
You can download the Git installer at http://msysgit.github.io/ .
##### Chocolatey
If you have installed Chocolatey, you can install Git with the following command:
~~~
choco install git
~~~

####Mercurial
Some software required by the `codyco-superbuild` (namely the Eigen library) are hosted in Mercurial repositories, so you will need Mercurial to automatically download them.
You can download the Mercurial installer at http://mercurial.selenic.com/wiki/Download .
##### Chocolatey
If you have installed Chocolatey, you can install Monotone with the following command:
~~~
choco install hg
~~~

####CMake
To install CMake you can use the official installer available at http://www.cmake.org/cmake/resources/software.html .
It is recommended to install the latest version of CMake.
##### Chocolatey
If you have installed Chocolatey, you can install CMake with the following command:
~~~
choco install cmake
~~~


####Eigen
Eigen can be automaically installed with the codyco-superbuild, so you don't have to install it manually.

If you want to install Eigen manually, or you have already installed Eigen please check the following section.
#### Manual installation
You can install Eigen from source code available from the [Eigen official website](http://eigen.tuxfamily.org).
You can simply extract the Eigen source code in a directory, and then define the `EIGEN3_ROOT` environment variable to the path of the directory that contains the file `signature_of_eigen3_matrix_library` (it should be the first directory contained in the compressed file).

####Boost
Some software of codyco-superbuild requires Boost. If you have already a copy of the Boost libraries
installed on your system, you can use them for compiling codyco-superbuild by defining the appropriate
`BOOST_DIR`, `BOOST_LIBRARYDIR` and `BOOST_INCLUDEDIR` enviroment variables.

####YARP & iCub
For installing the latest version of YARP and ICUB software, please refer to [the official iCub documentation](http://wiki.icub.org/wiki/ICub_Software_Installation).

###Superbuild
If you didn't already configured your git, you have to set your name and email to sign your commits:
```
git config --global user.name FirstName LastName
git config --global user.email user@email.domain
```
After that you can clone the superbuild repository as any other git repository, and generate the Visual Studio solution using the CMake gui. Then you open the generated solution with Visual Studio and build the target `all`.
Visual Studio will then download, build and install in a local directory all the CoDyCo software and its dependencies.
If you prefer to work from the command line, you can also compile the `all` target using the following command (if you are in the `codyco-superbuild/build` directory:
~~~
cmake --build .
~~~

###Configure your environment
Currently the YCM superbuild does not support building a global install target, so all binaries are installed in `codyco-superbuild/build/install/bin` and all libraries in `codyco-superbuild/build/install/lib`.

To use this binaries and libraries, you should update the necessary environment variables.

Set the environment variable `CODYCO_SUPERBUILD_ROOT` so that it points to the  directory where you clone the codyco-superbuild repository.

Append `$CODYCO_SUPERBUILD_ROOT/build/install/bin` to your PATH

Append `$CODYCO_SUPERBUILD_ROOT/build/install/share/codyco` to your [YARP\_DATA\_DIRS](http://wiki.icub.org/yarpdoc/yarp_data_dirs.html) environment variable.

Update
======
For updating the codyco-superbuild repository it is possible to just fetch the last changes using the usual
git command:
~~~
git pull
~~~
However, for running the equivalent of `git pull` on all the repositories managed by
the codyco-superbuild, you have to execute in your build system the appropriate target.
To do this, make sure to be in the `build` directory of the `codyco-superbuild` and execute:
~~~
make update-all
~~~
using make on Linux or OS X or
~~~
cmake --build . --target UPDATE_ALL
~~~
using Visual Studio on Windows or 
~~~
cmake --build . --target ALL_UPDATE
~~~
usuing Xcode On OS X.

MATLAB software
===============

Libraries
--------
If [MATLAB](mathworks.com/products/matlab/) is installed on your computer, the codyco-superbuild
can install some libraries that depend on MATLAB, in particular:
 * MATLAB bindings of the [iDynTree](https://github.com/robotology/idyntree) library.
 * MATLAB bindings of the [qpOASES](https://github.com/robotology-dependencies/qpOASES) library.
 * The [WB-Toolbox](https://github.com/robotology/WB-Toolbox) Simulink toolbox. 
 
To use this software, you can simply enable its compilation using the `CODYCO_USES_MATLAB` CMake option. 
Once this software has been compiled by the superbuild, you just need to add some directories of the codyco-superbuild install (typically `$CODYCO_SUPERBUILD_ROOT/build/install`) to [the MATLAB path](http://mathworks.com/help/matlab/matlab_env/add-folders-to-search-path-upon-startup-on-unix-or-macintosh.html).
In particular you need to add to the MATLAB path the `$CODYCO_SUPERBUILD_ROOT/build/install/mex` directory and all the subdirectories `$CODYCO_SUPERBUILD_ROOT/build/install/share/WB-Toolbox`.

As an example, you could add this line to your MATLAB script that uses the codyco-superbuild matlab software:
~~~
    addpath(['codyco_superbuild_install_folder'  /mex])
    addpath(genpath(['codyco_superbuild_install_folder'  /share/WB-Toolbox]))
~~~
Anyway we strongly suggest that you add this directories to the MATLAB path in robust way, 
for example by modifyng the `startup.m` or the `MATLABPATH` enviromental variable [as described in official MATLAB documentation](http://mathworks.com/help/matlab/matlab_env/add-folders-to-search-path-upon-startup-on-unix-or-macintosh.html)

For more info on configuring MATLAB software with the codyco-superbuild, please check the [WB-Toolbox README](https://github.com/robotology/WB-Toolbox).

**Note: the legacy WBI-Toolbox 1.0 (old version of WB-Toolbox) is still enabled by the `CODYCO_USES_WBI_TOOLBOX` flag, but is going to be removed from the `codyco-superbuild` on September 1st 2016.
  Please update your Simulink controllers using the [the migration guide from WBI-Toolbox 1.0](https://github.com/robotology/WB-Toolbox/blob/master/doc/Migration.md). The [software for estimating motor and joint friction parameters](https://github.com/robotology-playground/torque-control-params-estimation) still depends on WBI-Toolbox 1.0. The removal of this last dependency is tracked in an [issue on that repo](https://github.com/robotology-playground/torque-control-params-estimation/issues/32).**

Controllers
-----------
MATLAB controllers developed in the CoDyCo project are available in the [WBI-Toolbox-controllers](https://github.com/robotology-playground/WBI-Toolbox-controllers) repository. 
Given that some users want to fully control this repository, it is not downloaded automically if you select the `CODYCO_USES_MATLAB` option. To download this repository as part of the superbuild, just enable the `CODYCO_USES_WBI_TOOLBOX_CONTROLLERS` CMake option. 
