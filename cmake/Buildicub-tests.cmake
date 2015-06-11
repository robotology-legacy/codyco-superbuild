# icub-tests
include(YCMEPHelper)
include(FindOrBuildPackage)

ycm_ep_helper(icub-tests TYPE GIT
                         STYLE GITHUB
                         REPOSITORY robotology/icub-tests.git
                         COMPONENT external
                         DEPENDS YARP
                                 ICUB)
