# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
# orocos_kdl and package kdl_codyco use export(PACKAGE <pkg>) that
# installs some files in ~/.cmake/packages/<pkg> that are used by cmake
# to locate the build directory for some packages.
# This messes up with the superbuild, because CMake will find the build
# directory, and therefore will not rebuild the package.
# Therefore we disable the package registry using
# NO_CMAKE_PACKAGE_REGISTRY
find_or_build_package(orocos_kdl QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(kdl_codyco QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(kdl_format_io QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(iDynTree QUIET)
find_or_build_package(paramHelp QUIET)
find_or_build_package(wholeBodyInterface QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(yarpWholeBodyInterface QUIET)
#find_or_build_package(modHelp QUIET)
find_or_build_package(sensorsInterfaces QUIET)
find_or_build_package(codycoCommons QUIET)

set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED "")
if(${CODYCO_USES_URDFDOM})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_URDFDOM:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_URDFDOM:BOOL=OFF)
endif()

if(${CODYCO_USES_WBI_TOOLBOX})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_WBI_TOOLBOX:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_WBI_TOOLBOX:BOOL=OFF)
endif()

if(${CODYCO_TRAVIS_CI})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_TRAVIS_CI:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_TRAVIS_CI:BOOL=OFF)
endif()

if(${CODYCO_ICUBWBI_USE_EXTERNAL_TORQUE_CONTROL})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_ICUBWBI_USE_EXTERNAL_TORQUE_CONTROL:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_ICUBWBI_USE_EXTERNAL_TORQUE_CONTROL:BOOL=OFF)
endif()

ycm_ep_helper(codyco-modules TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/codyco-modules.git
              TAG master
              COMPONENT main
              CMAKE_CACHE_ARGS ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED}
              DEPENDS YARP
                      ICUB
                      orocos_kdl
                      kdl_codyco
                      kdl_format_io
                      iDynTree
                      paramHelp
                      wholeBodyInterface
                      yarpWholeBodyInterface
                      sensorsInterfaces
                      codycoCommons)
