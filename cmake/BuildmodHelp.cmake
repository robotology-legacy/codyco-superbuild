include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

ycm_ep_helper(modHelp TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/modHelp.git
              TAG master
              COMPONENT external
              DEPENDS YARP
                      ICUB)
