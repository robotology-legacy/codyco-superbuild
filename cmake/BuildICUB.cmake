# YARP
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(ICUB TYPE GIT
                   STYLE GITHUB
                   REPOSITORY robotology/icub-main.git
                   DEPENDS YARP
                   CMAKE_CACHE_ARGS -DYARP_USE_GTK2:BOOL=ON
                                    -DICUB_SHARED_LIBRARY:BOOL=ON
                                    -DICUB_USE_GLUT:BOOL=ON)
