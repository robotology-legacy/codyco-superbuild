# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(paramHelp TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/paramHelp.git
              TAG new_wbi_ID
              COMPONENT libraries
              DEPENDS YARP)
