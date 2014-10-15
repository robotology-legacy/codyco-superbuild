# kdl_codyco
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(orocos_kdl QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(console_bridge QUIET)
find_or_build_package(urdfdom_headers QUIET)
find_or_build_package(urdfdom QUIET)

ycm_ep_helper(kdl_format_io TYPE GIT
                            STYLE GITHUB
                            REPOSITORY robotology-playground/kdl_format_io.git
                            TAG master
                            COMPONENT libraries
                            CMAKE_CACHE_ARGS -DENABLE_IKIN:BOOL=ON 
                                             -DENABLE_URDF:BOOL=ON
                            DEPENDS orocos_kdl
                                    console_bridge
                                    urdfdom_headers
                                    urdfdom
                                    YARP
                                    ICUB)
