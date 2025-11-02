# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

# the Ion library

add_library(gadgetweatherion SHARED)

target_sources(gadgetweatherion PRIVATE
    ion.cpp
    ion.h
)

target_link_libraries(gadgetweatherion PUBLIC
    gadgetweatherdata
    KF6::UnitConversion
    KF6::Holidays
    KF6::I18n
    Qt::Qml
)

set_target_properties(gadgetweatherion PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   ${PROJECT_VERSION_MAJOR}
)

generate_export_header(gadgetweatherion)

install(TARGETS gadgetweatherion DESTINATION ${KDE_INSTALL_LIBDIR})

#add ions
add_subdirectory(wetter.com)
add_subdirectory(bbcukmet)
add_subdirectory(dwd)
add_subdirectory(envcan)
add_subdirectory(noaa)
