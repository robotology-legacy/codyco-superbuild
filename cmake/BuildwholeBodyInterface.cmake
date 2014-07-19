# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

ycm_ep_helper(wholeBodyInterface TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/wholeBodyInterface.git
              TAG master
              COMPONENT libraries)
