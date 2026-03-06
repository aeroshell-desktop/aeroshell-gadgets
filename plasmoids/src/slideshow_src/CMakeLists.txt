add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_io.gitgud.catpswin56.gadgets.slideshow\")

include_directories(/usr/include/Plasma /usr/include/PlasmaQuick /usr/include/KF6/KConfigCore/ /usr/include/KF6/KConfig/ /usr/include/KF6/KCoreAddons/)

plasma_install_package(package io.gitgud.catpswin56.gadgets.slideshow)

ecm_add_qml_module(slideshowplugin
    URI "io.gitgud.catpswin56.gadgets.slideshow"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES QtCore
)

target_sources(slideshowplugin PRIVATE slideshow.cpp)

target_link_libraries(slideshowplugin
    PRIVATE
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
)

ecm_finalize_qml_module(slideshowplugin)
