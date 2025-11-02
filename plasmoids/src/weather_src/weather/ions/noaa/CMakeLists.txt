# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

kcoreaddons_add_plugin(noaa INSTALL_NAMESPACE "catpswin56/weather-gadget/weather_ions")

target_sources(noaa PRIVATE
    ion_noaa.cpp
    ion_noaa.h
)

ecm_qt_declare_logging_category(noaa
    HEADER noaa_debug.h
    IDENTIFIER WEATHER::ION::NOAA
    CATEGORY_NAME io.gitgud.catpswin56.gadgets.weather.ion.noaa
    DEFAULT_SEVERITY Info
    DESCRIPTION "NOAA National Weather Service ion plugin"
    EXPORT GADGET
)

target_link_libraries(noaa PRIVATE
    gadgetweatherion
    KF6::KIOCore
)

install (FILES noaa_station_list.xml DESTINATION ${KDE_INSTALL_DATADIR}/catpswin56/weather-gadget)
