# orocos_kdl
include(YCMEPHelper)

ycm_ep_helper(orocos_kdl TYPE GIT
                         STYLE GITHUB
                         REPOSITORY traversaro/orocos_kinematics_dynamics.git
                         TAG workingFindEigen
                         COMPONENT external
                         CMAKE_CACHE_DEFAULT_ARGS -DOROCOSKDL_ENABLE_RPATH:BOOL=ON
                         CONFIGURE_SOURCE_DIR orocos_kdl)
