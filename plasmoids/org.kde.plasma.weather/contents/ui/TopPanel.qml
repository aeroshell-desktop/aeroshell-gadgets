/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents

ColumnLayout {
    property var generalModel: root.generalModel
    property var observationModel: root.observationModel
    property var model: root.forecastModel

    spacing: 0

    readonly property var currentWeatherTextColor: {
        // separated according to background color cuz i'm lazy to look in the resources folder every time
        // light background s
        "weather-clear": "black",
        "weather-clear-wind": "black",
        "weather-none-available": "black",
        "weather-snow-day": "black",

        // gray backgrounds
        "weather-clouds": "black",
        "weather-fog": "black",
        "weather-freezing-rain-day": "black",
        "weather-rain": "black",
        "weather-showers-scattered": "black",
        "weather-showers": "black",
        "weather-storm-day": "black",

        // dark backgrounds
        "weather-clear-night": "white",
        "weather-clear-wind-night": "white",
        "weather-clouds-night": "white",
        "weather-freezing-rain-night": "white",
        "weather-rain-night": "white",
        "weather-showers-scattered-night": "white",
        "weather-snow": "white",
        "weather-storm": "white",
    }

    Text {
        id: temp

        Layout.alignment: Qt.AlignRight

        text: observationModel.temperature
        elide: Text.ElideRight
        color: typeof currentWeatherTextColor[generalModel.currentConditionIconName] != "undefined" ? currentWeatherTextColor[generalModel.currentConditionIconName] : "black" // fallback
        font.pointSize: 16
    }
    Text {
        id: location

        Layout.preferredWidth: 175
        Layout.alignment: Qt.AlignRight

        text: generalModel.location
        elide: Text.ElideRight
        color: typeof currentWeatherTextColor[generalModel.currentConditionIconName] != "undefined" ? currentWeatherTextColor[generalModel.currentConditionIconName] : "black" // fallback
        font.pointSize: 10
    }
}
