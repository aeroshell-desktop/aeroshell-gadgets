# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

kcoreaddons_add_plugin(envcan INSTALL_NAMESPACE "catpswin56/weather-gadget/weather_ions")

target_sources(envcan PRIVATE
    ion_envcan.cpp
    ion_envcan.h
)

ecm_qt_declare_logging_category(envcan
    HEADER envcan_debug.h
    IDENTIFIER WEATHER::ION::ENVCAN
    CATEGORY_NAME io.gitgud.catpswin56.gadgets.weather.ion.envcan
    DEFAULT_SEVERITY Info
    DESCRIPTION "Canadian Weather ion plugin"
    EXPORT GADGET
)

target_link_libraries(envcan PRIVATE
    gadgetweatherion
    KF6::KIOCore
)
