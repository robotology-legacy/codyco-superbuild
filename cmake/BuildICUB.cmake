# ICUB
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(ICUB TYPE GIT
                   STYLE GITHUB
                   REPOSITORY robotology/icub-main.git
                   DEPENDS YARP
                   COMPONENT external
                   CMAKE_CACHE_ARGS -DICUB_SHARED_LIBRARY:BOOL=OFF
                                    -DENABLE_icubmod_cartesiancontrollerserver:BOOL=ON
                                    -DENABLE_icubmod_cartesiancontrollerclient:BOOL=ON
                                    -DENABLE_icubmod_gazecontrollerclient:BOOL=ON)
