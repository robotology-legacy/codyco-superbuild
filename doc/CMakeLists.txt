# Copyright (C) 2009 RobotCub Consortium
# Copyright (C) 2013-2014  iCub Facility, Istituto Italiano di Tecnologia
# Authors: Paul Fitzpatrick
#          Daniele E. Domenichelli
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT

find_package(Doxygen QUIET)

if(DOXYGEN_FOUND)
    set(DOX_GENERATE_HTML YES)
    set(DOX_GENERATE_XML NO)
    option(CODYCO_DOXYGEN_XML "Generate doxygen XML output, for use by SWIG" NO)
    mark_as_advanced(CODYCO_DOXYGEN_XML)
    if(CODYCO_DOXYGEN_XML)
        set(DOX_GENERATE_XML YES)
    endif()
    # CODYCO documentation is always verbose now.  It used to be
    # partially stripped of stuff less interesting to end-users.

    add_custom_target(dox COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    set(DOX_EXTRA_DIR ${CMAKE_CURRENT_SOURCE_DIR})

    get_property(_projects GLOBAL PROPERTY YCM_PROJECTS)
    foreach(_proj ${_projects})
        get_property(_component GLOBAL PROPERTY _YCM_${_proj}_COMPONENT)

        if(_component STREQUAL "external")
            if(TARGET ${_proj} AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.${_proj}.in)
                add_custom_target(${_proj}-dox COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/dox/tagfiles
                                               COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.${_proj})
                set(DOX_PATTERNS "") # Will use doxygen default patterns
                set(DOX_GENERATE_MAN NO)
                configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.${_proj}.in
                              ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.${_proj})
                add_dependencies(${_proj}-dox ${_proj}-update)
            endif()
        elseif(_component STREQUAL "documentation")
            set(DOX_EXTRA_DIR "${DOX_EXTRA_DIR} ${CMAKE_SOURCE_DIR}/${_component}/${_proj}")
            add_dependencies(dox ${_proj}) # documentation does not have an update target
        else()
            set(DOX_EXTRA_DIR "${DOX_EXTRA_DIR} ${CMAKE_SOURCE_DIR}/${_component}/${_proj}/doc")
            set(DOX_EXTRA_DIR "${DOX_EXTRA_DIR} ${CMAKE_SOURCE_DIR}/${_component}/${_proj}/src")
            set(DOX_EXTRA_DIR "${DOX_EXTRA_DIR} ${CMAKE_SOURCE_DIR}/${_component}/${_proj}/include")
            add_dependencies(dox ${_proj}-update)
        endif()
    endforeach()

    set(DOX_PATTERNS "") # Will use doxygen default patterns
    set(DOX_GENERATE_MAN NO)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
                   ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    set(DOX_GENERATE_HTML NO)
    set(DOX_GENERATE_MAN YES)
    set(DOX_GENERATE_XML NO)
    set(DOX_PATTERNS "cmd_*.dox")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in
                   ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.man)
    add_custom_target(man COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile.man)
endif()
