# Copyright (C) 2011-2013  Istituto Italiano di Tecnologia, Massachussets Institute of Techology
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
	set(Boost_VARIANT "debug" CACHE STRING "Possible values: debug, release")

else()
    set(LAYOUT "tagged")
    set(BUILD_TOOLSET "")
    set(EXT "sh")
    set(ADDRESS_MODEL "") # for linux??
	set(Boost_VARIANT "debug,release" CACHE STRING "Possible values: debug, release")

endif()

# Address components dependencies: unfortunatly boost build 
# system does not address for now automatic dependency resolution
# so we hardcode dependencies for the components we are interested in 
# (I know, it is ugly. But it works. As soon as things evolve on the Boost
#    side, we will promptly adapt. If you have any better idea please 
#    ping me at silvio DOT traversaro AT iit DOT it ).

# smart_ptr dependencies
set(smart_ptr_BOOST_COMPONENTS_DEPENDS throw_exception)

# iterator dependencies
set(iterator_BOOST_COMPONENTS_DEPENDS static_assert)

# range dependencies
set(range_BOOST_COMPONENTS_DEPENDS iterator)
list(APPEND range_BOOST_COMPONENTS_DEPENDS 
            ${iterator_BOOST_COMPONENTS_DEPENDS})

# mpl dependencies
set(mpl_BOOST_COMPONENTS_DEPENDS preprocessor)

# type_traits dependencies
set(type_traits_BOOST_COMPONENTS_DEPENDS mpl)
list(APPEND type_traits_BOOST_COMPONENTS_DEPENDS 
            ${mpl_BOOST_COMPONENTS_DEPENDS})

# thread dependencies
set(thread_BOOST_COMPONENTS_DEPENDS config)

# system dependencies
set(system_BOOST_COMPONENTS_DEPENDS core
                                    config
                                    assert
                                    utility
                                    predef)

# filesystem dependencies
set(filesystem_BOOST_COMPONENTS_DEPENDS system
                                        type_traits
                                        detail
                                        range
                                        smart_ptr
                                        io
                                        functional)
foreach(_comp_dep ${filesystem_BOOST_COMPONENTS_DEPENDS})
        message(STATUS "Adding dep " ${_comp_deb})
	list(APPEND filesystem_BOOST_COMPONENTS_DEPENDS 
                    ${${_comp_dep}_BOOST_COMPONENTS_DEPENDS})
endforeach()



# Expand dependencies (NOTE: it does not address recursive dependencies)
set(BOOST_BUILD_COMPONENTS_WITH_DEPS "")
foreach(_comp ${BOOST_BUILD_COMPONENTS})
    list(APPEND BOOST_BUILD_COMPONENTS_WITH_DEPS ${_comp})
    foreach(_comp_dep ${${_comp}_BOOST_COMPONENTS_DEPENDS})
        list(APPEND BOOST_BUILD_COMPONENTS_WITH_DEPS ${_comp_dep})
    endforeach()
endforeach()

# Remove duplicated components
list(REMOVE_DUPLICATES BOOST_BUILD_COMPONENTS_WITH_DEPS)

#Some boost components need to be compiled, keep a list from proper adding options
#incomplete list, TODO FIXME update with information from
# http://www.boost.org/doc/libs/1_56_0/more/getting_started/windows.html#header-only-libraries
set(COMPONENTS_TO_COMPILE filesystem
                          system
                          wave
                          chrono
                          date_time)

#Add the submodules that is necessary to pull 
#given the requested submodules. Some are added
#by default becuase are necessary for building
#the boost library
#adding also libs/wave by default, not really clear
#why this is required
set(COMPONENTS_SUBMODULES tools/build
                          tools/inspect
                          libs/wave)

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

ExternalProject_add(Boost
                    GIT_REPOSITORY "https://github.com/boostorg/boost"
                    GIT_TAG "master"
                    GIT_SUBMODULES ${COMPONENTS_SUBMODULES}
                    BUILD_IN_SOURCE 1
                    SOURCE_DIR  ${CMAKE_SOURCE_DIR}/external/boost
                    INSTALL_DIR ${CMAKE_BINARY_DIR}/install
                    CONFIGURE_COMMAND <SOURCE_DIR>/bootstrap.${EXT} ${CONF_TOOLSET}
                    BUILD_COMMAND <SOURCE_DIR>/b2 ${BUILD_TOOLSET} ${MAKE_ARGS} ${ADDRESS_MODEL} 
                                                  variant=${Boost_VARIANT}
                                                  link=static 
                                                  threading=multi 
                                                  runtime-link=shared
                                                  -d0 
                                                  --layout=${LAYOUT}
                                                  --prefix=${EXTERNAL_PREFIX}
                                                  ${COMPONENTS_COMPILE_OPTIONS}
                                                  install
                    INSTALL_COMMAND ""
)

if(NOT MSVC)

    set(Boost_SERIALIZATION_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_serialization-mt.a)

    set(Boost_DATE_TIME_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_date_time-mt.a)

    set(Boost_FILESYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_filesystem-mt.a)

    set(Boost_UNIT_TEST_FRAMEWORK_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_unit_test_framework-mt.a)

    set(Boost_SYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_system-mt.a)

    set(Boost_SIGNALS_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_signals-mt.a)

set(Boost_INCLUDE_DIR ${EXTERNAL_PREFIX}/include)

else()

set(TAG_TOOLSET ${CONF_TOOLSET}0)
if(${Boost_VARIANT} STREQUAL release)
    set(Boost_SERIALIZATION_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_serialization-${TAG_TOOLSET}-mt-1_55.lib)

    set(Boost_DATE_TIME_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_date_time-${TAG_TOOLSET}-mt-1_55.lib)

    set(Boost_FILESYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_filesystem-${TAG_TOOLSET}-mt-1_55.lib)

    set(Boost_UNIT_TEST_FRAMEWORK_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_unit_test_framework-${TAG_TOOLSET}-mt-1_55.lib)

    set(Boost_SYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_system-${TAG_TOOLSET}-mt-1_55.lib)

    set(Boost_SIGNALS_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_signals-${TAG_TOOLSET}-mt-1_55.lib)
else()
    set(Boost_SERIALIZATION_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_serialization-${TAG_TOOLSET}-mt-gd-1_55.lib)

    set(Boost_DATE_TIME_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_date_time-${TAG_TOOLSET}-mt-gd-1_55.lib)

    set(Boost_FILESYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_filesystem-${TAG_TOOLSET}-mt-gd-1_55.lib)

    set(Boost_UNIT_TEST_FRAMEWORK_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_unit_test_framework-${TAG_TOOLSET}-mt-gd-1_55.lib)

    set(Boost_SYSTEM_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_system-${TAG_TOOLSET}-mt-gd-1_55.lib)

    set(Boost_SIGNALS_LIBRARY ${EXTERNAL_PREFIX}/lib/libboost_signals-${TAG_TOOLSET}-mt-gd-1_55.lib)
endif()

set(Boost_INCLUDE_DIRS ${EXTERNAL_PREFIX}/include/boost-1_55)
set(Boost_INCLUDE_DIR ${EXTERNAL_PREFIX}/include)


endif()



set(Boost_FOUND 1)
set_target_properties(Boost PROPERTIES EXCLUDE_FROM_ALL 1)

