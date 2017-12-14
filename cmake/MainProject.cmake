set(${PROJECT_NAME}_VERSION 1.0.0)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)

# CMakeLists files in this project can refer to the root source directory of the 
# project as ${project_src_dir}


if(NOT CMAKE_BUILD_TYPE)
  set( CMAKE_BUILD_TYPE Debug CACHE STRING
       "Choose the type of build, options are: None Debug Release RelWithDebInfo
#MinSizeRel." FORCE)
endif()

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${${PROJECT_NAME}_SOURCE_DIR}/build/install" CACHE PATH "default install path" FORCE )
endif()


# Follows the convention of put all of the libs in "build/lib" and all
# of the exes in "build/bin".  To distingusih between debugging, release, and
# other builds, we'll add a postfix to the name of the lib or exe that we generate.

if(NOT CMAKE_DEBUG_POSTFIX)
  set(CMAKE_DEBUG_POSTFIX "")
endif()
set(CMAKE_RELEASE_POSTFIX "")
set(CMAKE_RELWITHDEBINFO_POSTFIX "rd")
set(CMAKE_MINSIZEREL_POSTFIX "s")

if (CMAKE_BUILD_TYPE MATCHES "Release")
  set(CMAKE_BUILD_POSTFIX "${CMAKE_RELEASE_POSTFIX}")
elseif (CMAKE_BUILD_TYPE MATCHES "MinSizeRel")
  set(CMAKE_BUILD_POSTFIX "${CMAKE_MINSIZEREL_POSTFIX}")
elseif (CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo")
  set(CMAKE_BUILD_POSTFIX "${CMAKE_RELWITHDEBINFO_POSTFIX}")
elseif (CMAKE_BUILD_TYPE MATCHES "Debug")
  set(CMAKE_BUILD_POSTFIX "${CMAKE_DEBUG_POSTFIX}")
else()
  set(CMAKE_BUILD_POSTFIX "")
endif()

set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -D${PROJECT_NAME}_DEBUG")

make_directory(${CMAKE_BINARY_DIR}/lib)
make_directory(${CMAKE_BINARY_DIR}/bin)
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
foreach (CONF ${CMAKE_CONFIGURATION_TYPES})
  string (TOUPPER ${CONF} CONF)
  set (CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONF} ${CMAKE_BINARY_DIR}/bin)
  set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONF} ${CMAKE_BINARY_DIR}/lib)
  set (CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONF} ${CMAKE_BINARY_DIR}/lib)
endforeach(CONF CMAKE_CONFIGURATION_TYPES)

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  # Linux specific code
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC") 
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC") 
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  # Apple-specific code
  set(CMAKE_CXX_FLAGS "-DOSX")
endif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

if (WIN32)
  # Windows-specific
endif (WIN32)

add_definitions(-DINSTALLPATH="${CMAKE_INSTALL_PREFIX}")

set(project_src_dir ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(dependency_dir ${CMAKE_CURRENT_SOURCE_DIR}/external)
set(plugins_install_dir ${CMAKE_INSTALL_PREFIX}/plugins)

include_directories(
  ${project_src_dir}
)

# Organize folder structure for Xcode, Visual Studio, etc.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

