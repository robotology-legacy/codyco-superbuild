# icub-tests
include(YCMEPHelper)
include(FindOrBuildPackage)

ycm_ep_helper(icub-tests TYPE GIT
                         STYLE GITHUB
                         REPOSITORY robotology/icub-tests.git
                         COMPONENT external
                         DEPENDS YARP
                                 ICUB
                                 RTF
                                 yarpWholeBodyInterface
                         CMAKE_ARGS -DICUB_TESTS_USES_CODYCO:BOOL=ON)
