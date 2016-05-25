cmake_minimum_required(VERSION 2.8.11)
project(codyco-superbuild NONE)

## we have to enable C because it is currently used
## by CMake to describe packages (in Config*.cmake files)
enable_language(C)

# Disable in source build
if("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
   message(FATAL_ERROR "In-source builds of codyco-superbuild are not allowed. "
                       "Please remove CMakeCache.txt and the CMakeFiles/ directory, then build out-of-source. "
                       "If you really want to do an in-source build, feel free to comment out this error.")
endif("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")

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
option(CODYCO_USES_MATLAB "Enable compilation of software that depend on Matlab and Simulink" FALSE)
option(CODYCO_NOT_USE_SIMULINK "Disable compilation of software that depend on Simulink" FALSE)
mark_as_advanced(CODYCO_NOT_USE_SIMULINK)
option(CODYCO_USES_WBI_TOOLBOX "Legacy version of Whole Body Interface Toolbox 1.0 - Simulink library" FALSE)
option(CODYCO_USES_WBI_TOOLBOX_CONTROLLERS "Controllers and Simulink models created/used with the WBI-Toolbox" FALSE)

option(CODYCO_USES_LUA "Enable compilation of software that depend on Lua" FALSE)
option(CODYCO_USES_PYTHON "Enable compilation of software that depend on Python" FALSE)
option(CODYCO_USES_OROCOS_BFL_BERDY "Forked Orocos Bayesian Filtering Library" FALSE)
option(CODYCO_USES_KDL "Enable compilation of software that depends on KDL" TRUE)
option(CODYCO_BUILD_ICUB_MODEL_GENERATOR "Enable compilation of the icub-model-generator" FALSE)
option(CODYCO_BUILD_OCRA_MODULES "Enable compilation of ISIR controllers" FALSE)
option(CODYCO_BUILD_QPOASES "Enable compilation of qpOASES" TRUE)

# Enable packages that depend on the Gazebo simulator
option(CODYCO_USES_GAZEBO "Enable compilation of software that depends on Gazebo" FALSE)

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
if(NOT CMAKE_VERSION VERSION_LESS 3.1)
    cmake_policy(SET CMP0054 NEW)
endif()


# Bootstrap YCM
set(YCM_TAG master)
include(YCMBootstrap)

include(FindOrBuildPackage)
include(YCMEPHelper)


if(MSVC)
    find_or_build_package(Eigen3)
else()
    find_package(Eigen3 3.2 REQUIRED)
endif()

find_or_build_package(YARP 2.3.63.2)
find_or_build_package(ICUB)
find_or_build_package(yarpWholeBodyInterface)

find_or_build_package(codyco-modules)

#codyco isir modules
if(${CODYCO_USES_KDL} AND ${CODYCO_BUILD_OCRA_MODULES} )
    find_or_build_package(ocra-wbi-plugins)
endif()

#WB-Toolbox
if (${CODYCO_USES_KDL} AND ${CODYCO_USES_MATLAB} AND NOT ${CODYCO_NOT_USE_SIMULINK})
    find_or_build_package(WBToolbox)
endif()

#WBI-Toolbox
if (${CODYCO_USES_KDL} AND ${CODYCO_USES_WBI_TOOLBOX})
    find_or_build_package(WBIToolbox)
endif()

#WBI-Toolbox-controllers
if (${CODYCO_USES_WBI_TOOLBOX_CONTROLLERS})
    find_or_build_package(WBIToolboxControllers)
endif()

#Orocos BFL-BERDY
if (${CODYCO_USES_OROCOS_BFL_BERDY})
    find_or_build_package(orocosBFLBerdy)
endif()

#mex wholeBodyModel interface
if (${CODYCO_USES_KDL} AND ${CODYCO_USES_MATLAB})
   find_or_build_package(mexWholeBodyModel)
endif()

#icub-model-generator
if (${CODYCO_BUILD_ICUB_MODEL_GENERATOR})
    find_or_build_package(icub-model-generator)
endif()

#qpOASES
if (${CODYCO_BUILD_QPOASES})
    find_or_build_package(qpOASES)
endif()

# adding test related subprojces
if (${CODYCO_COMPILE_TESTS})
    find_or_build_package(RTF)
    find_or_build_package(icub-tests)
endif()

# Gazebo related projects
if(${CODYCO_USES_GAZEBO})
    find_or_build_package(GazeboYARPPlugins)
    find_or_build_package(icub-gazebo)
endif()

#Documentation
add_subdirectory(doc)

set_package_properties(Git PROPERTIES TYPE RUNTIME)
set_package_properties(Subversion PROPERTIES TYPE RUNTIME)
set_package_properties(PkgConfig PROPERTIES TYPE RUNTIME)
set_package_properties(Doxygen PROPERTIES TYPE RUNTIME)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
