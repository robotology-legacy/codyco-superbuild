# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)


ycm_ep_helper(icub-model-generator TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology-playground/icub-model-generator.git
              TAG master
              COMPONENT codyco-misc
              DEPENDS YARP
                      ICUB
                      iDynTree)
