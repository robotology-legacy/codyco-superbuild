# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(TinyXML QUIET)
find_or_build_package(urdfdom_headers QUIET)

ycm_ep_helper(urdfdom TYPE GIT
              STYLE GITHUB
              REPOSITORY traversaro/urdfdom.git
              TAG master
              COMPONENT external
              DEPENDS urdfdom_headers
                      TinyXML
              CMAKE_CACHE_ARGS -DURDFDOM_DO_NOT_INSTALL_URDFPARSERPY:BOOL=ON
                               -DURDFDOM_DO_NOT_USE_CONSOLEBRIDGE:BOOL=ON)
