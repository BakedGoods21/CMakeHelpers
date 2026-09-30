MACRO (InstallExternalLib ExternalLib ExternalLibTarget ExternalLibBuildInstallLocation ExternalLibReleaseInstallLocation)

    CMAKE_PARSE_ARGUMENTS(InstallExternalLib
        ""
        ""
        ""
        ${ARGN}
    )

    # Set default values if the user omitted the keyword
    set(BuildInstallLocation "${CMAKE_BINARY_DIR}/lib")
    set(ReleaseInstallLocation "lib")
    if(NOT "${ExternalLibBuildInstallLocation}" STREQUAL "")
        set(BuildInstallLocation "${ExternalLibBuildInstallLocation}")
    endif()
    if(NOT "${ExternalLibReleaseInstallLocation}" STREQUAL "")
        set(ReleaseInstallLocation "${ExternalLibReleaseInstallLocation}")
        MESSAGE(STATUS "Setting release install location: ${ExternalLibReleaseInstallLocation}")
    endif()

    get_target_property(target_LIB ${ExternalLibTarget} LOCATION)
    get_filename_component(target_DIRECTORY ${target_LIB} DIRECTORY)
    get_filename_component(target_FILENAME ${target_LIB} NAME_WE)
    file(GLOB ${ExternalLib}_LIBS "${target_DIRECTORY}/${target_FILENAME}.so*")

    message(STATUS "${ExternalLib}_DIR: ${${ExternalLib}_DIR}")
    message(STATUS "${ExternalLib} libraries for ${ExternalLibTarget} are at: ${target_DIRECTORY}")
    message(STATUS "Libraries found: ${${ExternalLib}_LIBS}")


    add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/lib"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${${ExternalLib}_LIBS}
                "${BuildInstallLocation}"
        COMMENT "Copying dependent libraries to build directory"
    )

    install(FILES
        ${${ExternalLib}_LIBS}
        DESTINATION ${ReleaseInstallLocation}
    )
ENDMACRO ()
