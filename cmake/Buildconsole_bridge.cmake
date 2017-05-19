# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

ycm_ep_helper(console_bridge TYPE GIT
              STYLE GITHUB
              REPOSITORY ros/console_bridge.git
              TAG 0.3.2
              COMPONENT external)
