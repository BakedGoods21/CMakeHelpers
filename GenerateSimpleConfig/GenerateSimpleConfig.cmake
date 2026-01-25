include(CMakePackageConfigHelpers)

MACRO (GenerateLibraryConfig LibraryName CMakeInFile)

    CMAKE_PARSE_ARGUMENTS(GenerateLibraryConfig
        ""
        ""
        ""
        ${ARGN}
    )

    if (NOT DEFINED CMakeInFile)
        message(STATUS "Setting default library config template to: ${CMAKE_SOURCE_DIR}/CMakeHelpers/GenerateSimpleConfig/MyLibConfig.cmake.in")
        set(CMakeInFile "${CMAKE_SOURCE_DIR}/CMakeHelpers/GenerateSimpleConfig/MyLibConfig.cmake.in")
    endif()

    write_basic_package_version_file(
        "${CMAKE_CURRENT_BINARY_DIR}/${LibraryName}ConfigVersion.cmake"
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion
    )

    configure_package_config_file(
        "${CMAKE_SOURCE_DIR}/CMakeHelpers/GenerateSimpleConfig/MyLibConfig.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${LibraryName}Config.cmake"
        INSTALL_DESTINATION lib/cmake/${LibraryName}
    )

    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${LibraryName}Config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${LibraryName}ConfigVersion.cmake"
        DESTINATION lib/cmake/${LibraryName}
    )

    install(TARGETS ${PROJECT_NAME}
            DESTINATION lib
            EXPORT ${LibraryName}Targets
    )

    install(EXPORT ${LibraryName}Targets
            DESTINATION lib/cmake/${LibraryName}
            NAMESPACE ${LibraryName}::
    )

ENDMACRO ()

