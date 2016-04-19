# RTF
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)

ycm_ep_helper(RTF TYPE GIT
                  STYLE GITHUB
                  REPOSITORY robotology/robot-testing.git
                  CMAKE_CACHE_ARGS -DENABLE_MIDDLEWARE_PLUGINS:BOOL=ON
                                   -DENABLE_LUA_PLUGIN:BOOL=${CODYCO_USES_LUA}
                                   -DENABLE_PYTHON_PLUGIN:BOOL=${CODYCO_USES_PYTHON}
                  DEPENDS YARP
                  COMPONENT external)

