# kdl_codyco
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(orocos_kdl QUIET NO_CMAKE_PACKAGE_REGISTRY)

ycm_ep_helper(kdl_codyco TYPE GIT
                         STYLE GITHUB
                         REPOSITORY traversaro/kdl_codyco.git
                         TAG master
                         COMPONENT external
                         DEPENDS orocos_kdl)
