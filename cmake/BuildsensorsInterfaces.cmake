include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

ycm_ep_helper(sensorsInterfaces TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/sensorsInterfaces.git
              TAG master
              COMPONENT misc
              DEPENDS YARP
                      ICUB)
