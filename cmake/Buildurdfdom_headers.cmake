# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)


find_or_build_package(TinyXML QUIET)

ycm_ep_helper(urdfdom_headers TYPE GIT
              STYLE GITHUB
              REPOSITORY ros/urdfdom_headers.git
              TAG 0.4.2
              COMPONENT external
              DEPENDS TinyXML)
