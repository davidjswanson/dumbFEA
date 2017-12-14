macro (useOpenGL)
	# OpenGL
	find_package(OpenGL REQUIRED)
	set(OPENGL_LIBRARIES ${OPENGL_gl_LIBRARY} ${OPENGL_glu_LIBRARY})
	set(OPENGL_INCLUDE_DIRS ${OPENGL_INCLUDE_DIR})
	include_directories(${OPENGL_INCLUDE_DIRS})
	set(DEP_LIBS ${DEP_LIBS} ${OPENGL_LIBRARIES})

	# Windows Section #
	if (MSVC)
		add_definitions(-D_CRT_SECURE_NO_WARNINGS)
		# Tell MSVC to use main instead of WinMain for Windows subsystem executables
		set_target_properties(${WINDOWS_BINARIES} PROPERTIES LINK_FLAGS "/ENTRY:mainCRTStartup")
	endif()

	if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
		find_library(COCOA_LIB Cocoa)
		find_library(IOKIT_LIB IOKit)
		find_library(CORE_FOUNDATION_FRAMEWORK CoreFoundation)
			find_library(CORE_VIDEO_FRAMEWORK CoreVideo)
		set(DEP_LIBS ${DEP_LIBS} ${COCOA_LIB} ${IOKIT_LIB} ${CORE_FOUNDATION_FRAMEWORK} ${CORE_VIDEO_FRAMEWORK})
		message(STATUS "${CORE_VIDEO_FRAMEWORK}")
	endif()

	if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
		find_package(Threads)
		find_package(X11)
		set(DEP_LIBS ${DEP_LIBS} ${CMAKE_THREAD_LIBS_INIT} rt Xrandr Xxf86vm Xinerama Xcursor Xi m dl ${X11_LIBRARIES})
	endif()

	set(DEP_INCLUDES ${DEP_INCLUDES}
	  ${external_dir}/OpenGL/include
	)

endmacro()

# GLEW
macro (useGLEW)
	
	add_external(GLEW 
		URL https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.zip
		HEADER_ONLY
	)

	set(DEP_INCLUDES ${DEP_INCLUDES}
	  ${external_dir}/GLEW/src/include
	  ${external_dir}/GLEW/src/src
	)

	add_definitions(-DUSE_GLEW)

	set (DEP_SOURCEFILES ${DEP_SOURCEFILES} 
		${external_dir}/OpenGL/glew/glewProxy.cpp
	)
endmacro()

