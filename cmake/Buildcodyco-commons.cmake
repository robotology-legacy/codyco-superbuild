include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

ycm_ep_helper(codyco-commons TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/codyco-commons.git
              TAG master
              COMPONENT external
              DEPENDS YARP
                      ICUB)
