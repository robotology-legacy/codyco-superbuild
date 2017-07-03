# yarp-matlab-bindings
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(yarp-matlab-bindings TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/yarp-matlab-bindings.git
              TAG master
              COMPONENT libraries
              CMAKE_ARGS -DYARP_USES_MATLAB:BOOL=${CODYCO_USES_MATLAB}
                         -DYARP_USES_OCTAVE:BOOL=${CODYCO_USES_OCTAVE}
              DEPENDS YARP)
