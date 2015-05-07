# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(Boost QUIET)

ycm_ep_helper(console_bridge TYPE GIT
              STYLE GITHUB
              REPOSITORY ros/console_bridge.git
              TAG master
              COMPONENT external
              CMAKE_CACHE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON
			  DEPENDS Boost)
