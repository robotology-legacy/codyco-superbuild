# orocos_kdl
include(YCMEPHelper)

# orocos_kdl code to build is in the orocos_kdl subfolder, this is a
# workaround to fix it (adapted from ExternalProject.cmake) that passes
# all the required flags to cmake
#
# FIXME Fix this in ExternalProject (allow to build from a subdir
#       instead of the main source dir)
# WARNING CACHE ARGUMENTS CURRENTLY NOT IMPLEMENTED

get_target_property(cmake_command orocos_kdl _EP_CMAKE_COMMAND)
if(cmake_command)
  set(_cmake_cmd "${cmake_command}")
else()
  set(_cmake_cmd "${CMAKE_COMMAND}")
endif()

list(APPEND _cmake_cmd "@orocos_kdl_CMAKE_ARGS@")

get_target_property(cmake_generator orocos_kdl _EP_CMAKE_GENERATOR)
get_target_property(cmake_generator_toolset orocos_kdl _EP_CMAKE_GENERATOR_TOOLSET)
if(cmake_generator)
  list(APPEND _cmake_cmd "-G${cmake_generator}")
  if(cmake_generator_toolset)
    list(APPEND _cmake_cmd "-T${cmake_generator_toolset}")
  endif()
else()
  if(CMAKE_EXTRA_GENERATOR)
    list(APPEND _cmake_cmd "-G${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    list(APPEND _cmake_cmd "-G${CMAKE_GENERATOR}")
  endif()
  if(cmake_generator_toolset)
    message(FATAL_ERROR "Option CMAKE_GENERATOR_TOOLSET not allowed without CMAKE_GENERATOR.")
  endif()
  if(CMAKE_GENERATOR_TOOLSET)
    list(APPEND _cmake_cmd "-T${CMAKE_GENERATOR_TOOLSET}")
  endif()
endif()

list(APPEND _cmake_cmd "@orocos_kdl_SOURCE_DIR@/orocos_kdl")

#Appending RPATH option
list(APPEND _cmake_cmd "-DOROCOSKDL_ENABLE_RPATH:BOOL=ON")

ycm_ep_helper(orocos_kdl TYPE GIT
                         STYLE GITHUB
                         REPOSITORY traversaro/orocos_kinematics_dynamics.git
                         TAG workingFindEigen
                         COMPONENT external
                         CMAKE_CACHE_ARGS -DOROCOSKDL_ENABLE_RPATH:BOOL=ON #this is ignored because of $_cmake_cmd
                         CONFIGURE_COMMAND ${_cmake_cmd})
unset(_cmake_cmd)
