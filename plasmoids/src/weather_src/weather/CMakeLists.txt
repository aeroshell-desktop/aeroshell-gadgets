# SPDX-FileCopyrightText: 2025 Bohdan Onofriichuk <bogdan.onofriuchuk@gmail.com>
# SPDX-FileCopyrightText: 2025 catpswin56 <>
# SPDX-License-Identifier: BSD-3-Clause

add_definitions(-DTRANSLATION_DOMAIN=\"plasma_applet_io.gitgud.catpswin56.gadgets.weather\")

add_subdirectory(weatherdata)
add_subdirectory(ions)

plasma_add_applet(io.gitgud.catpswin56.gadgets.weather
    QML_SOURCES
        qml/ForecastView.qml
        qml/main.qml
        qml/MainLayout.qml
        qml/config/ConfigAppearance.qml
        qml/config/ConfigUnits.qml
        qml/config/ConfigWeatherStation.qml
        qml/config/config.qml
    CPP_SOURCES
        util.cpp
        abstractunitlistmodel.cpp
        locationscontrol.cpp
        forecastcontrol.cpp
        weatherdatamonitor_p.cpp
        abstractunitlistmodel.cpp
        ioncontrol_p.cpp
        forecastdata.cpp
        locationsdata.cpp
        types.h
    RESOURCES
        main.xml
        resources/sep-vert.png
        resources/sep-horiz.png
        resources/info.png

        resources/unexpanded/unexpanded-weather-clear.png
        resources/unexpanded/unexpanded-weather-clear-night.png
        resources/unexpanded/unexpanded-weather-clear-wind.png
        resources/unexpanded/unexpanded-weather-clear-wind-night.png
        resources/unexpanded/unexpanded-weather-clouds.png
        resources/unexpanded/unexpanded-weather-clouds-night.png
        resources/unexpanded/unexpanded-weather-few-clouds.png
        resources/unexpanded/unexpanded-weather-few-clouds-night.png
        resources/unexpanded/unexpanded-weather-fog.png
        resources/unexpanded/unexpanded-weather-freezing-rain-day.png
        resources/unexpanded/unexpanded-weather-freezing-rain-night.png
        resources/unexpanded/unexpanded-weather-none-available.png
        resources/unexpanded/unexpanded-weather-not-available.png
        resources/unexpanded/unexpanded-weather-overcast.png
        resources/unexpanded/unexpanded-weather-rain.png
        resources/unexpanded/unexpanded-weather-rain-night.png
        resources/unexpanded/unexpanded-weather-showers.png
        resources/unexpanded/unexpanded-weather-showers-scattered.png
        resources/unexpanded/unexpanded-weather-showers-scattered-night.png
        resources/unexpanded/unexpanded-weather-snow.png
        resources/unexpanded/unexpanded-weather-snow-day.png
        resources/unexpanded/unexpanded-weather-storm.png
        resources/unexpanded/unexpanded-weather-storm-day.png

        resources/expanded/expanded-weather-clear.png
        resources/expanded/expanded-weather-clear-night.png
        resources/expanded/expanded-weather-clear-wind.png
        resources/expanded/expanded-weather-clear-wind-night.png
        resources/expanded/expanded-weather-clouds.png
        resources/expanded/expanded-weather-clouds-night.png
        resources/expanded/expanded-weather-few-clouds.png
        resources/expanded/expanded-weather-few-clouds-night.png
        resources/expanded/expanded-weather-fog.png
        resources/expanded/expanded-weather-freezing-rain-day.png
        resources/expanded/expanded-weather-freezing-rain-night.png
        resources/expanded/expanded-weather-none-available.png
        resources/expanded/expanded-weather-not-available.png
        resources/expanded/expanded-weather-overcast.png
        resources/expanded/expanded-weather-rain.png
        resources/expanded/expanded-weather-rain-night.png
        resources/expanded/expanded-weather-showers.png
        resources/expanded/expanded-weather-showers-scattered.png
        resources/expanded/expanded-weather-showers-scattered-night.png
        resources/expanded/expanded-weather-snow.png
        resources/expanded/expanded-weather-snow-day.png
        resources/expanded/expanded-weather-storm.png
        resources/expanded/expanded-weather-storm-day.png
    GENERATE_APPLET_CLASS
)

ecm_qt_declare_logging_category(io.gitgud.catpswin56.gadgets.weather
    HEADER weathercontroller_debug.h
    IDENTIFIER WEATHER::CONTROLLER
    CATEGORY_NAME io.gitgud.catpswin56.gadgets.weather.controller
    DEFAULT_SEVERITY Info
    DESCRIPTION "Weather controller"
    EXPORT GADGET
)

target_link_libraries(io.gitgud.catpswin56.gadgets.weather PRIVATE
    KF6::UnitConversion
    KF6::I18n
    Qt::Core
    Qt::DBus
    Qt::Qml
    Qt::Network
    Qt::Gui
    KF6::KIOCore
    gadgetweatherion
    gadgetweatherdata
)
