include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)

ycm_ep_helper(codycoCommons TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/codyco-commons.git
              TAG master
              COMPONENT libraries
              DEPENDS YARP
                      ICUB
                      iDynTree)
