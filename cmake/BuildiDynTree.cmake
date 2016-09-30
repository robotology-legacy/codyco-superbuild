# iDynTree
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(YARP QUIET)
find_or_build_package(ICUB QUIET)

find_or_build_package(TinyXML QUIET)

# iDynTree is being migrated to be indipendent from urdfdom/orocos_kdl and thus boost
# Consequently, depending on the CODYCO_USES_KDL option it compile the part that depends
# on Boost (kdl, model_io, etc) or not
set(iDynTree_DEPENDS)

list(APPEND iDynTree_DEPENDS YARP)
list(APPEND iDynTree_DEPENDS ICUB)
list(APPEND iDynTree_DEPENDS TinyXML)


if(${CODYCO_USES_KDL})
    # orocos_kdl and package kdl_codyco use export(PACKAGE <pkg>) that
    # installs some files in ~/.cmake/packages/<pkg> that are used by cmake
    # to locate the build directory for some packages.
    # This messes up with the superbuild, because CMake will find the build
    # directory, and therefore will not rebuild the package.
    # Therefore we disable the package registry using
    # NO_CMAKE_PACKAGE_REGISTRY
    find_or_build_package(orocos_kdl QUIET NO_CMAKE_PACKAGE_REGISTRY)
    list(APPEND iDynTree_DEPENDS orocos_kdl)

    if( NOT MSVC )
        find_or_build_package(urdfdom_headers QUIET)
        find_or_build_package(urdfdom QUIET)
        list(APPEND iDynTree_DEPENDS urdfdom_headers)
        list(APPEND iDynTree_DEPENDS urdfdom)
    endif()
endif()


ycm_ep_helper(iDynTree TYPE GIT
              STYLE GITHUB
              REPOSITORY robotology/idyntree.git
              TAG master
              COMPONENT libraries
              CMAKE_ARGS -DIDYNTREE_USES_MATLAB:BOOL=${CODYCO_USES_MATLAB}
                         -DIDYNTREE_USES_PYTHON:BOOL=${CODYCO_USES_PYTHON}
                         -DIDYNTREE_USES_OCTAVE:BOOL=${CODYCO_USES_OCTAVE}
                         -DIDYNTREE_USES_KDL=${CODYCO_USES_KDL}
              DEPENDS ${iDynTree_DEPENDS})
