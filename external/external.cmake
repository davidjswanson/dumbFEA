if(NOT external_dir)
	set(external_dir ${CMAKE_SOURCE_DIR}/external)
endif()

function(add_external DepName)
  unset(dep_current_param)

  foreach(var IN LISTS ARGN)
	if (NOT dep_current_param)
		if (${var} MATCHES "HEADER_ONLY")
			set(${DepName}_${var} True)
		else()
			set(dep_current_param ${var})
		endif()
	else()
		set(${DepName}_${dep_current_param} ${var})
		#message("${DepName}_${dep_current_param}=${var}")
		unset(dep_current_param)
	endif()
  endforeach()

	set(${DepName}_checkout_Dir ${external_dir}/${DepName}/src)
	set(${DepName}_build_dir ${external_dir}/${DepName}/build/${CMAKE_BUILD_TYPE})
	set(${DepName}_stamp_dir ${${DepName}_build_dir}/stamp)
	set(${DepName}_tmp_dir ${${DepName}_build_dir}/tmp)

	set(${DepName}_PREFIX "${${DepName}_checkout_Dir}")
	set(${DepName}_INSTALL_DIR "${${DepName}_build_dir}/../install")

	#message("Args: " ${${${DepName}_CMAKE_ARGS}})

	set(${DepName}_CMAKE_ARGS ${${${DepName}_CMAKE_ARGS}} -DCMAKE_INSTALL_PREFIX=${${DepName}_INSTALL_DIR} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})
	set(${DepName}_DIR "${${DepName}_INSTALL_DIR}")

	if (NOT TARGET ${DepName})
		make_directory(${${DepName}_checkout_Dir})
		include(ExternalProject)

		if (${DepName}_GIT_REPOSITORY)
			if (NOT ${DepName}_GIT_TAG)
				set(${DepName}_GIT_TAG "master")
			endif()
	
			if (${DepName}_HEADER_ONLY)
				ExternalProject_add(${DepName}
						PREFIX ${${DepName}_PREFIX}
						GIT_REPOSITORY "${${DepName}_GIT_REPOSITORY}"
						GIT_TAG ${${DepName}_GIT_TAG}
						INSTALL_DIR ${${DepName}_INSTALL_DIR}
						CMAKE_ARGS ${${DepName}_CMAKE_ARGS}
						UPDATE_COMMAND ""
						DOWNLOAD_DIR ${${DepName}_checkout_Dir}
						SOURCE_DIR ${${DepName}_checkout_Dir}
						TMP_DIR ${${DepName}_tmp_dir}
						STAMP_DIR ${${DepName}_stamp_dir}
						BINARY_DIR ${${DepName}_build_dir}
						PATCH_COMMAND "${${DepName}_PATCH_COMMAND}"
						BUILD_COMMAND ""
						CONFIGURE_COMMAND ""
						INSTALL_COMMAND ""
				)
			else()
				ExternalProject_add(${DepName}
						PREFIX ${${DepName}_PREFIX}
						GIT_REPOSITORY "${${DepName}_GIT_REPOSITORY}"
						GIT_TAG ${${DepName}_GIT_TAG}
						INSTALL_DIR ${${DepName}_INSTALL_DIR}
						CMAKE_ARGS ${${DepName}_CMAKE_ARGS}
						UPDATE_COMMAND ""
						DOWNLOAD_DIR ${${DepName}_checkout_Dir}
						SOURCE_DIR ${${DepName}_checkout_Dir}
						TMP_DIR ${${DepName}_tmp_dir}
						STAMP_DIR ${${DepName}_stamp_dir}
						BINARY_DIR ${${DepName}_build_dir}
						PATCH_COMMAND "${${DepName}_PATCH_COMMAND}"
				)

			endif()
		endif()

		if (${DepName}_URL)
		  get_filename_component(DepFileName ${${DepName}_URL} NAME)
		  set(DepFileName ${external_dir}/zip_files/${DepFileName})
			if (EXISTS ${DepFileName})
			  set(${DepName}_URL ${DepFileName})
			endif()
		  
			if (${DepName}_HEADER_ONLY)
				ExternalProject_add(${DepName}
						PREFIX ${${DepName}_PREFIX}
						URL "${${DepName}_URL}"
						INSTALL_DIR ${${DepName}_INSTALL_DIR}
						CMAKE_ARGS ${${DepName}_CMAKE_ARGS}
						UPDATE_COMMAND ""
						DOWNLOAD_DIR ${${DepName}_checkout_Dir}
						SOURCE_DIR ${${DepName}_checkout_Dir}
						TMP_DIR ${${DepName}_tmp_dir}
						STAMP_DIR ${${DepName}_stamp_dir}
						BINARY_DIR ${${DepName}_build_dir}
						PATCH_COMMAND "${${DepName}_PATCH_COMMAND}"
						BUILD_COMMAND ""
						CONFIGURE_COMMAND ""
						INSTALL_COMMAND ""
				)
			else()
				ExternalProject_add(${DepName}
						PREFIX ${${DepName}_PREFIX}
						URL "${${DepName}_URL}"
						INSTALL_DIR ${${DepName}_INSTALL_DIR}
						CMAKE_ARGS ${${DepName}_CMAKE_ARGS}
						UPDATE_COMMAND ""
						DOWNLOAD_DIR ${${DepName}_checkout_Dir}
						SOURCE_DIR ${${DepName}_checkout_Dir}
						TMP_DIR ${${DepName}_tmp_dir}
						STAMP_DIR ${${DepName}_stamp_dir}
						BINARY_DIR ${${DepName}_build_dir}
						PATCH_COMMAND "${${DepName}_PATCH_COMMAND}"
				)
			endif()
		endif()

		set_property(TARGET ${DepName} PROPERTY FOLDER "external")

		install(DIRECTORY ${${DepName}_INSTALL_DIR}/ DESTINATION "${external_dir}/${DepName}")

	endif()

	if (NOT ${DepName}_HEADER_ONLY)
		set(DEP_INCLUDES ${DEP_INCLUDES} ${${DepName}_INSTALL_DIR}/include PARENT_SCOPE)
		set(DEP_LINK_DIRS ${DEP_LINK_DIRS} ${${DepName}_INSTALL_DIR}/lib PARENT_SCOPE)
		#include_directories(${${DepName}_INSTALL_DIR}/include)
		#link_directories(${${DepName}_INSTALL_DIR}/lib)

		if (${DepName}_LIB_NAME)
			set(lib_name ${${DepName}_LIB_NAME})
			if(MSVC)
				set(DEP_LIBS ${DEP_LIBS} ${${DepName}_LIB_NAME} optimized ${${DepName}_LIB_NAME}.lib debug ${lib_name}d.lib PARENT_SCOPE)
			else()
				set(DEP_LIBS ${DEP_LIBS} ${${DepName}_LIB_NAME} optimized lib${${DepName}_LIB_NAME}.a debug lib${lib_name}d.a PARENT_SCOPE)
			endif()
		endif()
	endif()

	set(PROJECT_DEPS ${PROJECT_DEPS} ${DepName} PARENT_SCOPE)
endfunction()



