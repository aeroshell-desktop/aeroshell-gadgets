# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

kcoreaddons_add_plugin(bbcukmet INSTALL_NAMESPACE "catpswin56/weather-gadget/weather_ions")

target_sources(bbcukmet PRIVATE
    ion_bbcukmet.cpp
    ion_bbcukmet.h
)

ecm_qt_declare_logging_category(bbcukmet
    HEADER bbcukmet_debug.h
    IDENTIFIER WEATHER::ION::BBCUKMET
    CATEGORY_NAME io.gitgud.catpswin56.gadgets.ion.bbcukmet
    DEFAULT_SEVERITY Info
    DESCRIPTION "BBC weather ion plugin"
    EXPORT GADGET
)

target_link_libraries(bbcukmet PRIVATE
    gadgetweatherion
    KF6::KIOCore
)
