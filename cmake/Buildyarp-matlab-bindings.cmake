# yarp-matlab-bindings
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)


ycm_ep_helper(yarp-matlab-bindings TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/yarp-matlab-bindings.git
              TAG master
              COMPONENT libraries
              DEPENDS YARP)
