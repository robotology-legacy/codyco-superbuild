include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)
find_or_build_package(wholeBodyInterface QUIET)
find_or_build_package(paramHelp QUIET)
find_or_build_package(motorFrictionIdentificationLib QUIET)

set(YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED "")

if(${CODYCO_ICUBWBI_USE_EXTERNAL_TORQUE_CONTROL})
    set(YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED ${YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED} -DICUBWBI_USE_EXTERNAL_TORQUE_CONTROL:BOOL=ON)
elseif()
    set(YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED ${YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED} -DICUBWBI_USE_EXTERNAL_TORQUE_CONTROL:BOOL=OFF)
endif()

ycm_ep_helper(yarpWholeBodyInterface TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/yarp-wholebodyinterface.git
              TAG master
              COMPONENT libraries
              CMAKE_CACHE_ARGS ${YARP_WBI_CMAKE_CACHE_ARGS_USER_DEFINED}
              DEPENDS YARP
                      ICUB
                      iDynTree
                      wholeBodyInterface
                      paramHelp
                      motorFrictionIdentificationLib)
