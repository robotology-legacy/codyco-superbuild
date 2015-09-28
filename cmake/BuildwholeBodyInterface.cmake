# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

ycm_ep_helper(wholeBodyInterface TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/wholebodyinterface.git
              TAG master
              COMPONENT libraries)
