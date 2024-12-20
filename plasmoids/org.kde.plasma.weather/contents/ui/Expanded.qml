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

    PlasmaExtras.PlaceholderMessage {
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.margins: Kirigami.Units.gridUnit
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

    PlasmaExtras.PlaceholderMessage {
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.margins: Kirigami.Units.largeSpacing * 4
        Layout.maximumWidth: Kirigami.Units.gridUnit * 20
        visible: root.status === Util.Timeout
        iconName: "network-disconnect"
        text: {
            const sourceTokens = root.weatherSource.split("|");
            return i18n("Unable to retrieve weather information for %1", sourceTokens[2]);
        }
        explanation: i18nc("@info:usagetip", "The network request timed out, possibly due to a server outage at the weather station provider. Check again later.")
    }


    property string currentWeather: "resources/expanded/" + generalModel.currentConditionIconName + ".png"

    readonly property var currentWeatherSeparatorColor: {
        // light background s
        "weather-clear": "#1473b3",
        "weather-clear-wind": "#1473b3",
        "weather-none-available": "#1473b3",
        "weather-snow-day": "#1473b3",

        // gray backgrounds
        "weather-clouds": "#808d94",
        "weather-fog": "#808d94",
        "weather-freezing-rain-day": "#808d94",
        "weather-rain": "#808d94",
        "weather-showers-scattered": "#808d94",
        "weather-showers": "#808d94",
        "weather-storm-day": "#808d94",

        // dark backgrounds
        "weather-clear-night": "#1c3f4e",
        "weather-clear-wind-night": "#1c3f4e",
        "weather-clouds-night": "#1c3f4e",
        "weather-freezing-rain-night": "#1c3f4e",
        "weather-rain-night": "#1c3f4e",
        "weather-showers-scattered-night": "#1c3f4e",
        "weather-snow": "#1c3f4e",
        "weather-storm": "#1c3f4e",
    }

    Image {
        id: background
        source: currentWeather
        Layout.preferredWidth: 264
        Layout.preferredHeight: 194
    }

    ColumnLayout { // DOULE LAYOUTs.......
        anchors.fill: background
        anchors.rightMargin: 23
        anchors.topMargin: 10
        anchors.leftMargin: 14
        spacing: 0

        TopPanel {
            id: topPanel

            Layout.alignment: Qt.AlignRight
        }

        Item {
            Layout.preferredHeight: 46
        }

        ForecastView {
            id: forecastPanel

            Layout.maximumWidth: 226
            Layout.fillHeight: true

            generalModel: root.generalModel
            model: root.forecastModel
        }

        PlasmaComponents.Label {
            id: sourceLabel
            visible: root.status === Util.Normal
            readonly property string creditUrl: generalModel.creditUrl

            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.maximumWidth: 226

            Image {
                anchors {
                    top: parent.top
                    right: parent.right
                    rightMargin: -2
                    left: parent.left
                }
                source: "resources/sep-horiz.png"
                height: 2
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
                cursorShape: !!parent.creditUrl ? Qt.PointingHandCursor : Qt.ArrowCursor
            }

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignLeft
            font {
                pointSize: Kirigami.Theme.smallFont.pointSize
                underline: !!creditUrl
            }
            linkColor: color
            opacity: 0.6
            textFormat: Text.StyledText

            text: {
                let result = generalModel.courtesy;
                if (creditUrl) {
                    result = "<a href=\"" + creditUrl + "\">" + result + "</a>";
                }
                return result;
            }

            onLinkActivated: link => {
                Qt.openUrlExternally(link);
            }
        }
    }
}
