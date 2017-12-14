include(${CMAKE_SOURCE_DIR}/external/external.cmake)

source_group("Header Files" FILES ${HEADERFILES})
source_group("Source Files" FILES ${SOURCEFILES})

macro (addStandardExecutable)
	if(DEP_INCLUDES)
		include_directories(${DEP_INCLUDES})
	endif()

	if(DEP_LINK_DIRS)
		link_directories(${DEP_LINK_DIRS})
	endif()

	add_executable (${PROJECT_NAME} ${HEADERFILES} ${SOURCEFILES} ${DEP_SOURCEFILES})

	if(PROJECT_DEPS)
		add_dependencies(${PROJECT_NAME} ${PROJECT_DEPS})
	endif()

	target_link_libraries(${PROJECT_NAME} ${DEP_LIBS} ${ALL_LIBS})

	# --------------------- Install -----------------------

	install( TARGETS ${PROJECT_NAME}
		     LIBRARY DESTINATION lib
		     ARCHIVE DESTINATION lib
		     RUNTIME DESTINATION bin)
endmacro()
