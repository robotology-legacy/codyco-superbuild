# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)
find_or_build_package(wholeBodyInterface QUIET)
find_or_build_package(yarpWholeBodyInterface QUIET)


set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED "")

if(${CODYCO_USES_WB_TOOLBOX})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_WB_TOOLBOX:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_USES_WB_TOOLBOX:BOOL=OFF)
endif()

if(${CODYCO_TRAVIS_CI})
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_TRAVIS_CI:BOOL=ON)
elseif()
    set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED} -DCODYCO_TRAVIS_CI:BOOL=OFF)
endif()

ycm_ep_helper(WBToolbox TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/WB-Toolbox.git
              TAG master
              COMPONENT main
              CMAKE_CACHE_ARGS ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED}
              DEPENDS YARP
                      ICUB
                      iDynTree
                      wholeBodyInterface
                      yarpWholeBodyInterface)
