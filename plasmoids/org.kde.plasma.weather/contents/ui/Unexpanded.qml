/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

import org.kde.plasma.private.weather

ColumnLayout {
    id: fullRoot

    property var generalModel: root.generalModel
    property var observationModel: root.observationModel

    property string currentWeather: "resources/unexpanded/" + generalModel.currentConditionIconName + ".png"

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

    Image {
        id: background
        source: currentWeather
        width: 130
        height: 67

        PlasmaExtras.PlaceholderMessage {
            anchors.centerIn: parent
            // when not in panel, a configure button is already shown for needsConfiguration
            visible: (root.status === Util.NeedsConfiguration) && (Plasmoid.formFactor === PlasmaCore.Types.Vertical || Plasmoid.formFactor === PlasmaCore.Types.Horizontal)
            iconName: "mark-location"
            text: i18n("Please set your location")
            helpfulAction: QQC2.Action {
                icon.name: "configure"
                text: i18n("Set location…")
                onTriggered: {
                    Plasmoid.internalAction("configure").trigger();
                }
            }
        }
    }

    ColumnLayout {
        anchors {
            top: background.top
            topMargin: 1
            right: background.right
            rightMargin: 7
        }
        spacing: 0

        Item {
            Layout.preferredHeight: parent.height/2 + Kirigami.Units.smallSpacing - Kirigami.Units.smallSpacing/4

            visible: infoRow.visible
        }

        RowLayout {
            id: infoRow

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter

            visible: observationModel.temperature == "" && generalModel.location != "" || generalModel.currentConditionIconName == "weather-not-available"

            Item {
                Layout.fillWidth: true
            }

            Image {
                source: "resources/info.png"
            }

            Text {
                text: "Not available"
            }

            Item {
                Layout.fillWidth: true
            }
        }

        Text {
            id: temp

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: 115

            elide: Text.ElideRight
            text: observationModel.temperature
            font.pointSize: 16
            color: typeof currentWeatherTextColor[generalModel.currentConditionIconName] != "undefined" ? currentWeatherTextColor[generalModel.currentConditionIconName] : "black" // fallback
            horizontalAlignment: Text.AlignRight
            visible: !infoRow.visible
        }
        Text {
            id: location

            Layout.alignment: Qt.AlignRight
            Layout.preferredWidth: 115

            elide: Text.ElideRight
            text: generalModel.location
            font.pointSize: 9
            color: typeof currentWeatherTextColor[generalModel.currentConditionIconName] != "undefined" ? currentWeatherTextColor[generalModel.currentConditionIconName] : "black" // fallback
            horizontalAlignment: Text.AlignRight
            visible: !infoRow.visible
        }
    }
}
