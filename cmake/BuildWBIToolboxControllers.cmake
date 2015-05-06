# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

# find_or_build_package(WBIToolbox)

set(CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED "")

ycm_ep_helper(WBIToolboxControllers TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/WBI-Toolbox-controllers.git
              TAG master
              COMPONENT main
              CMAKE_CACHE_ARGS ${CODYCO_CMAKE_CACHE_ARGS_USER_DEFINED}
              DEPENDS WBIToolbox)
