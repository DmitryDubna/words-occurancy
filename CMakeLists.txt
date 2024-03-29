cmake_minimum_required(VERSION 3.16)

project(words-occurancy VERSION 0.1 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets Core Quick REQUIRED)

set(PROJECT_SOURCES
    main.cpp
    occurancy_item.h
    occurancy_item_container.h occurancy_item_container.cpp
    project_controller.h project_controller.cpp
    user_action_type.h
    utils.h
    resources/qml.qrc
)

# необходимо для автодополнения QML
set(QML2_IMPORT_PATH ${CMAKE_CURRENT_LIST_DIR}/resources/qml
    CACHE STRING "Qt Creator extra qml import paths"
    FORCE
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(words-occurancy
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
    qt_add_qml_module(words-occurancy
        URI Occurancy
        VERSION 1.0
        QML_FILES
            resources/main.qml
        SOURCES
            ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET words-occurancy APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(words-occurancy SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(words-occurancy
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(
    words-occurancy
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>
)

target_link_libraries(
    words-occurancy
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Widgets
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Quick
)

set_target_properties(
    words-occurancy
    PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(words-occurancy)
    qt_finalize_executable(words-occurancy)
endif()
