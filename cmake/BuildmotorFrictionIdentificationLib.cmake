include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(paramHelp QUIET)


ycm_ep_helper(motorFrictionIdentificationLib TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/codyco-motor-friction-identification-lib.git
              TAG master
              COMPONENT libraries
              DEPENDS YARP
                      paramHelp)
