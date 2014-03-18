# ModuleBasicExample
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP)

ycm_ep_helper(ModuleBasicExample TYPE GIT
                                 STYLE GITLAB_ICUB_ORG
                                 REPOSITORY walkman/modulebasicexample.git
                                 TAG master
                                 COMPONENT examples
                                 DEPENDS YARP
                                 INSTALL_COMMAND "")
