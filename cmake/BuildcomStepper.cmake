# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

ycm_ep_helper(comStepper TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/comStepper.git
              TAG master
              COMPONENT main
              DEPENDS YARP
                      ICUB)
