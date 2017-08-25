include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)
find_or_build_package(wholeBodyInterface QUIET)
find_or_build_package(icub-models QUIET)


ycm_ep_helper(yarpWholeBodyInterface TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/yarp-wholebodyinterface.git
              TAG master
              COMPONENT libraries
              CMAKE_ARGS -DYARPWBI_USES_KDL=${CODYCO_USES_KDL}
              DEPENDS YARP
                      ICUB
                      iDynTree
                      wholeBodyInterface
                      icub-models)
