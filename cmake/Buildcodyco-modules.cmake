# CoDyCo
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)
find_or_build_package(iDynTree QUIET)
find_or_build_package(paramHelp QUIET)
find_or_build_package(wholeBodyInterface QUIET NO_CMAKE_PACKAGE_REGISTRY)
find_or_build_package(yarpWholeBodyInterface QUIET)

set(codyco-module_DEPENDS)

list(APPEND codyco-module_DEPENDS YARP)
list(APPEND codyco-module_DEPENDS ICUB)
list(APPEND codyco-module_DEPENDS iDynTree)
list(APPEND codyco-module_DEPENDS paramHelp)
list(APPEND codyco-module_DEPENDS wholeBodyInterface)
list(APPEND codyco-module_DEPENDS yarpWholeBodyInterface)


if(${CODYCO_USES_KDL})
    find_or_build_package(codycoCommons QUIET)
    list(APPEND codyco-module_DEPENDS codycoCommons)
endif()

if (${CODYCO_USES_OROCOS_BFL_BERDY})
    find_or_build_package(orocosBFLBerdy QUIET)
    list(APPEND codyco-module_DEPENDS orocosBFLBerdy)
endif()



ycm_ep_helper(codyco-modules TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/codyco-modules.git
              TAG master
              COMPONENT main
              CMAKE_ARGS -DCODYCO_TRAVIS_CI:BOOL=${CODYCO_TRAVIS_CI}
                         -DCODYCO_USES_OROCOS_BFL_BERDY:BOOL=${CODYCO_USES_OROCOS_BFL_BERDY}
                         -DCODYCO_USES_KDL:BOOL=${CODYCO_USES_KDL}
              DEPENDS ${codyco-module_DEPENDS})
