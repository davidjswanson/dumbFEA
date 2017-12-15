project(dumbFEA)

cmake_minimum_required (VERSION 2.8.2) 

include(${CMAKE_SOURCE_DIR}/cmake/MainProject.cmake)

# -------------------------------- Dependencies --------------------------------

find_package(OpenMP QUIET)
if (OPENMP_FOUND)
        message("OpenMP Found")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
endif()

# -------------------------------- Project --------------------------------

#add_subdirectory(${dependency_dir}/NanoGUI/src)

#message(${NANOGUI_EXTRA_DEFS})
#message(${NANOGUI_EXTRA_INCS})
#message(${NANOGUI_EXTRA_LIBS})

add_subdirectory(apps)
