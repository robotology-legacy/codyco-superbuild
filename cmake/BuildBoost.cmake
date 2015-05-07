# Copyright (C) 2011-2015  Istituto Italiano di Tecnologia, Massachussets Institute of Techology
# Authors: Elena Ceseracciu  <elena.ceseracciu@iit.it>, 
#          Matteo Santoro    <msantoro@mit.edu>,
#          Silvio Traversaro <silvio.traversaro@iit.it>

include(ExternalProject)

############## Boost
if(MSVC)
    set(LAYOUT "versioned")
    set(EXT "bat")
    if(MSVC_VERSION GREATER 1699)
            set(CONF_TOOLSET "vc11")
            set(BUILD_TOOLSET "msvc-11.0")
    elseif(MSVC_VERSION GREATER 1599)
            set(CONF_TOOLSET "vc10")
            set(BUILD_TOOLSET "msvc-10.0")
    elseif(MSVC_VERSION GREATER 1499)
            set(CONF_TOOLSET "vc9")
            set(BUILD_TOOLSET "msvc-9.0")
    elseif(MSVC_VERSION GREATER 1399)
            set(CONF_TOOLSET "vc8")
            set(BUILD_TOOLSET "msvc-8.0")
    elseif(MSVC_VERSION GREATER 1299)
            set(CONF_TOOLSET "vc7")
            set(BUILD_TOOLSET "msvc-7.0")
    elseif(MSVC_VERSION GREATER 1199)
            message(FATAL_ERROR "vc6 is not supported by Boost: Please upgrade your compiler.")
    endif()
    set(BUILD_TOOLSET "toolset=${BUILD_TOOLSET}")
    
    if (CMAKE_CL_64)
        set(ADDRESS_MODEL "address-model=64")
    else()
        set(ADDRESS_MODEL "address-model=32")
    endif()
	set(Boost_VARIANT "release" CACHE STRING "Possible values: debug, release")

else()
    set(LAYOUT "tagged")
    set(BUILD_TOOLSET "")
    set(EXT "sh")
    set(ADDRESS_MODEL "") # for linux??
	set(Boost_VARIANT "release" CACHE STRING "Possible values: debug, release")

endif()

# Address components dependencies: unfortunatly boost build 
# system does not address for now automatic dependency resolution
# so we automatically extract boost dependency from boostdep,
# and we generated the BoostDependencies.cmake file with the 
# generateBoostDependencies.py script 
include(BoostDependencies)

# Expand dependencies 
# Note: we should not worry about indirected dependencies because
#       those dependencies are already expanded by the generateBoostDependencies.cmake script
set(BOOST_BUILD_COMPONENTS_WITH_DEPS "config" "wave")
message(STATUS "BOOST_BUILD_COMPONENTS :" ${BOOST_BUILD_COMPONENTS})
foreach(_comp ${BOOST_BUILD_COMPONENTS})
    message(STATUS "Considering component " ${_comp})
    list(APPEND BOOST_BUILD_COMPONENTS_WITH_DEPS ${_comp})
    foreach(_comp_dep ${${_comp}_BOOST_COMPONENTS_DEPENDS})
	    message(STATUS "Adding dependency " ${_comp_dep})
        list(APPEND BOOST_BUILD_COMPONENTS_WITH_DEPS ${_comp_dep})
    endforeach()
endforeach()

# Remove duplicated components
list(REMOVE_DUPLICATES BOOST_BUILD_COMPONENTS_WITH_DEPS)

#Some boost components need to be compiled, keep a list from proper adding options
#incomplete list, TODO FIXME update with information from
# http://www.boost.org/doc/libs/1_56_0/more/getting_started/windows.html#header-only-libraries
set(COMPONENTS_TO_COMPILE atomic
                          filesystem
                          system
                          wave
                          chrono
                          date_time
                          thread
                          exception
                          "math"
                          container)

#Add the submodules that is necessary to pull 
#given the requested submodules. Some are added
#by default becuase are necessary for building
#the boost library
#adding also libs/wave by default, not really clear
#why this is required (build otherwise always give an error)
# libs/config is added by default because it contains the version.hpp
# file used by FindBoost.cmake for checking Boost version
set(COMPONENTS_SUBMODULES tools/build
                          tools/inspect)

set(COMPONENTS_COMPILE_OPTIONS "")

foreach(_comp ${BOOST_BUILD_COMPONENTS_WITH_DEPS})
    message(STATUS "Considering component " ${_comp})
    list(APPEND COMPONENTS_SUBMODULES "libs/${_comp}")
    # if a requested library is not header only
    # we have to specify the proper option for building
    list(FIND COMPONENTS_TO_COMPILE ${_comp} result) 
    message(STATUS "Result is " ${result})
    if(NOT ${result} EQUAL -1)
        list(APPEND COMPONENTS_COMPILE_OPTIONS "--with-${_comp}")
    endif()
endforeach()

foreach(_comp ${COMPONENTS_TO_COMPILE})
    message(STATUS "The non header only libraries are " ${_comp})
endforeach()
            
foreach(_comp ${COMPONENTS_SUBMODULES})
    message(STATUS "We have to get submodule " ${_comp})
endforeach()

foreach(_comp ${COMPONENTS_COMPILE_OPTIONS})
    message(STATUS "We have to compile boost with option " ${_comp})
endforeach()

set(EXTERNAL_PREFIX ${CMAKE_BINARY_DIR}/install)

set(BOOST_BUILDING_TYPE shared)

ExternalProject_add(Boost
                    GIT_REPOSITORY "https://github.com/boostorg/boost"
                    GIT_TAG "master"
                    GIT_SUBMODULES ${COMPONENTS_SUBMODULES}
					GIT_DEPTH 1
                    BUILD_IN_SOURCE 1
                    SOURCE_DIR  ${CMAKE_SOURCE_DIR}/external/boost
                    INSTALL_DIR ${CMAKE_BINARY_DIR}/install
                    CONFIGURE_COMMAND <SOURCE_DIR>/bootstrap.${EXT} ${CONF_TOOLSET}
                    BUILD_COMMAND <SOURCE_DIR>/b2 ${BUILD_TOOLSET} ${MAKE_ARGS} ${ADDRESS_MODEL} 
                                                  variant=${Boost_VARIANT}
                                                  link=${BOOST_BUILDING_TYPE} 
                                                  threading=multi
												  pch=off
                                                  runtime-link=shared
                                                  -d0 
                                                  --layout=${LAYOUT}
                                                  --prefix=${EXTERNAL_PREFIX}
                                                  ${COMPONENTS_COMPILE_OPTIONS}
                                                  install
                    INSTALL_COMMAND ""
)


