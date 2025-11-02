# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

qt_add_library(gadgetweatherdata SHARED ${weatherdata_SRCS})

target_sources(gadgetweatherdata PRIVATE
    currentday.h
    currentday.cpp
    lastday.h
    lastday.cpp
    lastobservation.h
    lastobservation.cpp
    metadata.h
    metadata.cpp
    futuredays.h
    futuredays.cpp
    station.h
    station.cpp
    warnings.h
    warnings.cpp
    forecast.h
    forecast.cpp
    locations.h
    locations.cpp
)

generate_export_header(gadgetweatherdata)

target_link_libraries(gadgetweatherdata PRIVATE
    Qt::Core
    KF6::I18n
    KF6::UnitConversion
    Qt::Qml
)

set_target_properties(gadgetweatherdata PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   ${PROJECT_VERSION_MAJOR}
)

install(TARGETS gadgetweatherdata DESTINATION ${KDE_INSTALL_LIBDIR})
