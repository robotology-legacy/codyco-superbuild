cmake_minimum_required(VERSION 2.8.7)
project(CoDyCo-superbuild NONE)

## we have to enable C because it is currently used
## by CMake to describe packages (in Config*.cmake files)
enable_language(C)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

set(CODYCO-SUPERBUILD_MAJOR_VERSION 0)
set(CODYCO-SUPERBUILD_MINOR_VERSION 0)
set(CODYCO-SUPERBUILD_PATCH_VERSION 1)
set(CODYCO-SUPERBUILD_VERSION ${CODYCO-SUPERBUILD_MAJOR_VERSION}.${CODYCO-SUPERBUILD_MINOR_VERSION}.${CODYCO-SUPERBUILD_PATCH_VERSION})

include(CTest)
include(FeatureSummary)

set(YCM_USE_CMAKE_PROPOSED TRUE CACHE BOOL "Use files including unmerged cmake patches")

# Bootstrap YCM
include(YCMBootstrap)

include(FindOrBuildPackage)
include(YCMEPHelper)

find_or_build_package(YARP 2.3.60)
find_or_build_package(ICUB)
find_or_build_package(CoDyCo)

#modules
find_or_build_package(comStepper)

set_package_properties(Git PROPERTIES TYPE RUNTIME)
set_package_properties(Subversion PROPERTIES TYPE RUNTIME)
set_package_properties(PkgConfig PROPERTIES TYPE RUNTIME)
set_package_properties(Doxygen PROPERTIES TYPE RUNTIME)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
