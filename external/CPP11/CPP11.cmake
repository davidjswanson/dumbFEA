#------------------------------------------
# Specific preprocessor defines
#------------------------------------------
macro (useCPP11)
	# Windows Section #
	if (MSVC)
		add_definitions(-D_CRT_SECURE_NO_WARNINGS)
		# Tell MSVC to use main instead of WinMain for Windows subsystem executables
		set_target_properties(${WINDOWS_BINARIES} PROPERTIES LINK_FLAGS "/ENTRY:mainCRTStartup")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
	endif()

	if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		set(CMAKE_CXX_FLAGS "-std=c++11 -stdlib=libc++")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++11")
		set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
	endif()

	if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
	  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.7")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++0x")
	  else(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.7")
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
	  endif(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.7")
		find_package(Threads)
		find_package(X11)
		set(ALL_LIBS ${ALL_LIBS} ${CMAKE_THREAD_LIBS_INIT} rt Xrandr Xxf86vm Xi m dl ${X11_LIBRARIES})
	endif()
endmacro()
