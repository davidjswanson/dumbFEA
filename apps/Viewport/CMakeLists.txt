project (Viewport)

include(${CMAKE_SOURCE_DIR}/cmake/project.cmake)

# --------------------- Source -----------------------

set (SOURCEFILES
  src/main.cpp
)

set (HEADERFILES
)

# --------------------- Dependencies -----------------------


set(NanoGUIArgs -DNANOGUI_BUILD_SHARED=OFF -DNANOGUI_BUILD_PYTHON=OFF -DNANOGUI_BUILD_EXAMPLE=OFF -DCMAKE_C_FLAGS=-fPIC -DCMAKE_CXX_FLAGS=-fPIC  -DCMAKE_DEBUG_POSTFIX=d -DCMAKE_CONFIGURATION_TYPES='Debug Release MinSizeRel RelWithDebInfo')
add_external(NanoGUI 
	GIT_REPOSITORY https://github.com/wjakob/nanogui.git
	CMAKE_ARGS NanoGUIArgs
	LIB_NAME nanogui
)

include_directories(
	${dependency_dir}/NanoGUI/build/install/include
	${dependency_dir}/NanoGUI/src/ext/eigen
	${dependency_dir}/NanoGUI/src/ext/glfw/include
	${dependency_dir}/NanoGUI/src/ext/nanovg/src
)

include(${CMAKE_SOURCE_DIR}/external/OpenGL/OpenGL.cmake)
useOpenGL()

include(${CMAKE_SOURCE_DIR}/external/CPP11/CPP11.cmake)
useCPP11()

# --------------------- Executable -----------------------

addStandardExecutable()

