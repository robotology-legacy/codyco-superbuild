# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(TinyXML QUIET)
find_or_build_package(console_bridge  QUIET)
find_or_build_package(urdfdom_headers QUIET)

ycm_ep_helper(urdfdom TYPE GIT
              STYLE GITHUB
              REPOSITORY ros/urdfdom.git
              TAG 0.4
              COMPONENT external
              DEPENDS console_bridge
                      urdfdom_headers
                      TinyXML)
