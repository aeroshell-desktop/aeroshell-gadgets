/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 * SPDX-FileCopyrightText: 2025 catpswin56 <>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

Item {
    id: root

    readonly property bool isTemperaturePresent: !!root.lastObservation?.temperature && !!root.metaData?.temperatureUnit

    readonly property string currentWeather: (Plasmoid.configuration.prefersExpanded ? "expanded-" : "unexpanded-") + Plasmoid.icon + ".png"

    readonly property bool available: (root.lastObservation?.temperature ?? 0) != "" && location != "" && Plasmoid.icon != "weather-not-available"

    readonly property var currentWeatherTextColor: {
        // light backgrounds
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

    property var metaData: null
    property var lastObservation: null
    property string location: ""
    property var futureDays: null
    property int displayTemperatureUnit: 0

    width: background.width
    height: background.height

    Image {
        id: background

        source: currentWeather

        PlasmaExtras.PlaceholderMessage {
            anchors.centerIn: background
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

    RowLayout {
        id: infoRow

        anchors.fill: parent

        visible: !root.available

        Item { Layout.fillWidth: true }

        Image { source: "info.png" }
        Text { text: i18n("Not available"); color: "white" }

        Item { Layout.fillWidth: true }
    }

    ColumnLayout {
        anchors {
            left: background.left
            right: background.right
            top: background.top

            leftMargin: Plasmoid.configuration.prefersExpanded ? 14 : 9
            rightMargin: Plasmoid.configuration.prefersExpanded ? 23 : 7
            topMargin: Plasmoid.configuration.prefersExpanded ? 10 : 1
        }

        spacing: 0

        Text {
            id: temp

            Layout.alignment: Qt.AlignRight

            Layout.fillWidth: true

            elide: Text.ElideRight
            text: root.isTemperaturePresent ? Util.temperatureToDisplayString(root.displayTemperatureUnit, root.lastObservation.temperature, root.metaData.temperatureUnit, true, false) : ""
            font.pointSize: 16
            color: typeof currentWeatherTextColor[Plasmoid.icon] != "undefined" ? currentWeatherTextColor[Plasmoid.icon] : "black" // fallback
            horizontalAlignment: Text.AlignRight

            visible: root.available
        }
        Text {
            id: location

            Layout.alignment: Qt.AlignRight

            Layout.fillWidth: true

            elide: Text.ElideRight
            text: root.location
            font.pointSize: 9
            color: typeof currentWeatherTextColor[Plasmoid.icon] != "undefined" ? currentWeatherTextColor[Plasmoid.icon] : "black"
            horizontalAlignment: Text.AlignRight

            visible: root.available
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.topMargin: 46

            spacing: 0

            visible: Plasmoid.configuration.prefersExpanded

            ForecastView {
                id: forecastPanel

                Layout.leftMargin: forecastPanel.spacing

                Layout.fillWidth: true
                Layout.fillHeight: true

                futureDays: root.futureDays
                metaData: root.metaData
                displayTemperatureUnit: root.displayTemperatureUnit
            }

            PlasmaComponents.Label {
                id: sourceLabel

                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true

                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 8
                linkColor: color
                opacity: 0.6
                textFormat: Text.StyledText

                text: {
                    let result = "";
                    if (!!metaData?.credit) {
                        if (!!metaData.creditURL) {
                            result = "<a href=\"" + root.metaData.creditURL + "\">" + root.metaData.credit + "</a>";
                            font.underline = true;
                        } else {
                            result = root.metaData.credit;
                        }
                    }
                    return result;
                }

                onLinkActivated: (link) => Qt.openUrlExternally(link);

                visible: text !== ""

                Image {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top

                        rightMargin: -2
                    }

                    height: 2

                    source: "sep-horiz.png"
                }

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                    cursorShape: parent.font.underline ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
            }
        }
    }
}
