macro (useAssimp)
	set(AssimpArgs -DBUILD_SHARED_LIBS=OFF -DASSIMP_BUILD_ASSIMP_TOOLS=OFF -DASSIMP_BUILD_SAMPLES=OFF -DASSIMP_ENABLE_BOOST_WORKAROUND=ON -DASSIMP_BUILD_TESTS=OFF)

	add_external(Assimp 
		GIT_REPOSITORY https://github.com/assimp/assimp.git
		CMAKE_ARGS AssimpArgs
		LIB_NAME assimp
	)

	find_package(ZLIB)
	if( NOT ZLIB_FOUND )
	   ExternalProject_Get_Property(AssimpLib binary_dir)
		set(DEP_INCLUDES ${DEP_INCLUDES} ${binary_dir}/contrib/zlib)
		set(DEP_LINK_DIRS ${DEP_LINK_DIRS}
	   		${binary_dir}/contrib/zlib/Release
	   		${binary_dir}/contrib/zlib/Debug
		)
	   link_directories(
	   )
	   set(ZLIB_LIBRARIES optimized zlibstatic.lib debug zlibstaticd.lib)
	endif(NOT ZLIB_FOUND)
	set(DEP_LIBS ${DEP_LIBS} ${ZLIB_LIBRARIES})

	add_external(IrrXML 
		URL http://prdownloads.sourceforge.net/irrlicht/irrxml-1.2.zip
		HEADER_ONLY
	)

	set(DEP_INCLUDES ${DEP_INCLUDES} ${external_dir}/IrrXML/src/src)
	set(DEP_SOURCEFILES ${DEP_SOURCEFILES} ${external_dir}/Assimp/irrXML/irrXMLProxy.cpp)

endmacro()
