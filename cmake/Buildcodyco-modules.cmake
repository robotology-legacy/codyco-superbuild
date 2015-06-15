# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

find_or_build_package(iDynTree QUIET)
find_or_build_package(paramHelp QUIET)
find_or_build_package(wholeBodyInterface QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(yarpWholeBodyInterface QUIET)
#find_or_build_package(modHelp QUIET)
find_or_build_package(sensorsInterfaces QUIET)
find_or_build_package(InSituFTCalibration QUIET)

if (${CODYCO_USES_EIGEN_320})
	find_or_build_package(codycoCommons QUIET)
endif()

if (${CODYCO_USES_OROCOS_BFL_BERDY})
	find_or_build_package(orocosBFLBerdy QUIET)
endif()

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

if(${CODYCO_USES_EIGEN_320})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_EIGEN_320:BOOL=ON)
    set(CODYCO_COMMONS_DEPENDENCY codycoCommons)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_EIGEN_320:BOOL=OFF)
endif()

if(${CODYCO_USES_OROCOS_BFL_BERDY})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_OROCOS_BFL_BERDY:BOOL=ON)
    set(CODYCO_OROCOS_BFL_BERDY_DEPENDENCY orocosBFLBerdy)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_OROCOS_BFL_BERDY:BOOL=OFF)
endif()

ycm_ep_helper(codyco-modules TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/codyco-modules.git
              TAG master
              COMPONENT main
              CMAKE_CACHE_ARGS ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED}
              DEPENDS YARP
                      ICUB
                      iDynTree
                      paramHelp
                      wholeBodyInterface
                      yarpWholeBodyInterface
                      sensorsInterfaces
                      InSituFTCalibration
                      ${CODYCO_COMMONS_DEPENDENCY}
                      ${CODYCO_OROCOS_BFL_BERDY_DEPENDENCY})
