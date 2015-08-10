cmake_minimum_required(VERSION 2.8.11)
project(codyco-superbuild NONE)

## we have to enable C because it is currently used
## by CMake to describe packages (in Config*.cmake files)
enable_language(C)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CODYCO-SUPERBUILD_MAJOR_VERSION 0)
set(CODYCO-SUPERBUILD_MINOR_VERSION 2)
set(CODYCO-SUPERBUILD_PATCH_VERSION 0)
set(CODYCO-SUPERBUILD_VERSION ${CODYCO-SUPERBUILD_MAJOR_VERSION}.${CODYCO-SUPERBUILD_MINOR_VERSION}.${CODYCO-SUPERBUILD_PATCH_VERSION})

include(CTest)
include(FeatureSummary)

set(YCM_USE_CMAKE_PROPOSED TRUE CACHE BOOL "Use files including unmerged cmake patches")

#Compilation options

#options to build specific software or use a reduced set of dependencies
option(CODYCO_USES_MATLAB "Enable compilation of software that depend on Matlab" FALSE)
option(CODYCO_MATLAB_DEPENDENCIES_CUSTOM "Enables the custom selection of some Matlab dependencies" FALSE)
option(CODYCO_USES_LUA "Enable compilation of software that depend on Lua" FALSE)
option(CODYCO_USES_PYTHON "Enable compilation of software that depend on Python" FALSE)
option(CODYCO_USES_WBI_TOOLBOX "Whole Body Interface Toolbox - Simulink library" FALSE)
option(CODYCO_USES_WBI_TOOLBOX_CONTROLLERS "Controllers and Simulink models created/used with the WBI-Toolbox" FALSE)
option(CODYCO_USES_OROCOS_BFL_BERDY "Forked Orocos Bayesian Filtering Library" FALSE)
option(CODYCO_USES_URDFDOM "Enable support for URDF input in iDynTree" TRUE)
option(CODYCO_BUILD_ICUB_MODEL_GENERATOR "Enable compilation of the icub-model-generator" FALSE)
option(CODYCO_USES_EIGEN_320 "Enable compilation of software that depends on Eigen 3.2.0 (if false just depend on Eigen 3.0.5)" FALSE)
option(CODYCO_BUILD_ISIR_MODULES "Enable compilation of ISIR controllers" TRUE)
option(CODYCO_BUILD_QPOASES "Enable compilation of qpOASES" TRUE)
option(CODYCO_USES_MEX_WHOLEBODYMODEL "Enable to compile the matlab mex inteface for iWholeBodyModel" FALSE)
# option(CODYCO_DISABLE_RPATH "Disable installation with RPATH" FALSE) ##TODO: how to control all the RPATH variables of sub-projects?
# mark_as_advanced(CODYCO_DISABLE_RPATH)


option(IDYNTREE_USES_MATLAB "Compile iDynTree Matlab bindings" FALSE)

#set default build type to "Release" in single-config generators
if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING
        "Choose the type of build, recommanded options are: Debug or Release" FORCE)
    endif()
    set(CODYCO_BUILD_TYPES "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS ${CODYCO_BUILD_TYPES})
endif()

#options for testing
option(CODYCO_COMPILE_TESTS "Compile tests using the robot testing framework" FALSE)
option(CODYCO_TRAVIS_CI "Set if build is done with Travis-CI flags" FALSE)

# Optionally load a file named ProjectsTags
# for overwriting the desired branch/tag/commit
# of the included subprojects of the superbuild
# Useful for having superbuild "branches"
include(ProjectsTags OPTIONAL)

#Set CMake policies
if(NOT CMAKE_VERSION VERSION_LESS 3.0)
    cmake_policy(SET CMP0045 OLD)
endif()

# Bootstrap YCM
set(YCM_TAG 671740c84a98023c4554dcc12318ac1c513171e7)
include(YCMBootstrap)

include(FindOrBuildPackage)
include(YCMEPHelper)


if(MSVC)
    find_or_build_package(Eigen3)
else()
    if(CODYCO_USES_EIGEN_320)
    	find_package(Eigen3 3.2 REQUIRED)
    endif()
endif()

find_or_build_package(YARP 2.3.63.2)
find_or_build_package(ICUB)
find_or_build_package(yarpWholeBodyInterface)

#build codyco-modules and codycoCommons library only if the use of Eigen 3.2 is enabled
find_or_build_package(codyco-modules)

#codyco isir modules
if( ${CODYCO_BUILD_ISIR_MODULES} )
    find_or_build_package(ocra-wbi-plugins)
endif()

#additional modules
find_or_build_package(comStepper)

#Set WBI-Toolbox and mexWholeBodyModel variables depending on CODYCO_USES_MATLAB
if(NOT ${CODYCO_MATLAB_DEPENDENCIES_CUSTOM})
    set(CODYCO_USES_WBI_TOOLBOX ${CODYCO_USES_MATLAB} CACHE BOOL "Whole Body Interface Toolbox - Simulink library" FORCE)
    set(CODYCO_USES_MEX_WHOLEBODYMODEL ${CODYCO_USES_MATLAB} CACHE BOOL "Enable to compile the matlab mex inteface for iWholeBodyModel" FORCE)
endif()

#WBI-Toolbox
if( ${CODYCO_USES_WBI_TOOLBOX} )
    find_or_build_package(WBIToolbox)
endif()

#WBI-Toolbox-controllers
if( ${CODYCO_USES_WBI_TOOLBOX_CONTROLLERS} )
    find_or_build_package(WBIToolboxControllers)
endif()

#Orocos BFL-BERDY
if (${CODYCO_USES_OROCOS_BFL_BERDY})
    find_or_build_package(orocosBFLBerdy)
endif()

#mex wholeBodyModel interface
if( ${CODYCO_USES_MEX_WHOLEBODYMODEL} )
   find_or_build_package(mexWholeBodyModel)
endif()

#icub-model-generator
if(${CODYCO_BUILD_ICUB_MODEL_GENERATOR})
    find_or_build_package(icub-model-generator)
endif()

#qpOASES
if(${CODYCO_BUILD_QPOASES})
    find_or_build_package(qpOASES)
endif()

# adding test related subprojces
if(${CODYCO_COMPILE_TESTS})
    find_or_build_package(RTF)
    find_or_build_package(icub-tests)
endif()

#Documentation
add_subdirectory(doc)

set_package_properties(Git PROPERTIES TYPE RUNTIME)
set_package_properties(Subversion PROPERTIES TYPE RUNTIME)
set_package_properties(PkgConfig PROPERTIES TYPE RUNTIME)
set_package_properties(Doxygen PROPERTIES TYPE RUNTIME)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
