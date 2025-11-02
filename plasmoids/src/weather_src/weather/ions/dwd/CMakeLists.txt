# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

kcoreaddons_add_plugin(dwd INSTALL_NAMESPACE "catpswin56/weather-gadget/weather_ions")

target_sources(dwd PRIVATE
    ion_dwd.cpp
    ion_dwd.h
)

ecm_qt_declare_logging_category(dwd
    HEADER dwd_debug.h
    IDENTIFIER WEATHER::ION::DWD
    CATEGORY_NAME io.gitgud.catpswin56.gadgets.weather.ion.dwd
    DEFAULT_SEVERITY Info
    DESCRIPTION "German Meteorological Service ion plugin"
    EXPORT GADGET
)

target_link_libraries(dwd PRIVATE
    gadgetweatherion
    KF6::KIOCore
)
