/*
    SPDX-FileCopyrightText: 2012 Viranch Mehta <viranch.mehta@gmail.com>
    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support

PlasmoidItem {
    id: analogclock

    Layout.minimumWidth: 124
    Layout.minimumHeight: 124
    Layout.maximumWidth: 124
    Layout.maximumHeight: 124

    readonly property string currentTime: Qt.locale().toString(dataSource.data["Local"]["DateTime"], Qt.locale().timeFormat(Locale.LongFormat))
    readonly property string currentDate: Qt.locale().toString(dataSource.data["Local"]["DateTime"], Qt.locale().dateFormat(Locale.LongFormat).replace(/(^dddd.?\s)|(,?\sdddd$)/, ""))

    property int hours
    property int minutes
    property int seconds
    property bool showSecondsHand: Plasmoid.configuration.showSecondHand
    property bool showTimezone: Plasmoid.configuration.showTimezoneString
    property int tzOffset

    Plasmoid.backgroundHints: "NoBackground";

    function dateTimeChanged() {
        var currentTZOffset = dataSource.data["Local"]["Offset"] / 60;
        if (currentTZOffset !== tzOffset) {
            tzOffset = currentTZOffset;
            Date.timeZoneUpdated(); // inform the QML JS engine about TZ change
        }
    }

    P5Support.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: "Local"
        interval: showSecondsHand || (analogclock.compactRepresentationItem && analogclock.compactRepresentationItem.containsMouse) ? 1000 : 30000
        onDataChanged: {
            var date = new Date(data["Local"]["DateTime"]);
            hours = date.getHours();
            minutes = date.getMinutes();
            seconds = date.getSeconds();
        }
        Component.onCompleted: dataChanged();
    }

    Accessible.name: Plasmoid.title
    Accessible.description: i18nc("@info:tooltip", "Current time is %1; Current date is %2", analogclock.currentTime, analogclock.currentDate)
    Accessible.role: Accessible.Button

    Styles { id: styles }

    Item {
        id: clock

        anchors.fill: parent

        Image {
            id: face
            anchors.centerIn: parent
            source: "clocks/" + styles.currentStyle.styleName + "/clock.png"
        }

        Hand {
            id: hourHand
            rotation: 180 + hours * 30 + (minutes/2)
            source: "clocks/" + styles.currentStyle.styleName + "/hour.png"
        }

        Hand {
            id: minuteHand
            rotation: 180 + minutes * 6
            source: "clocks/" + styles.currentStyle.styleName + "/minute.png"
        }

        Hand {
            id: secondHand
            visible: showSecondsHand
            rotation: 180 + seconds * 6
            source: "clocks/" + styles.currentStyle.styleName + "/second.png"
        }

        Image {
            anchors.centerIn: face
            source: "clocks/" + styles.currentStyle.styleName + "/pin.png"
        }

        Image {
            anchors.centerIn: face
            source: "clocks/" + styles.currentStyle.styleName + "/shine.png"
            visible: clockStyles.currentStyle.hasShine
        }
    }

    KSvg.FrameSvgItem {
        id: timezoneBg

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 10
        }
        width: childrenRect.width + margins.right + margins.left
        height: childrenRect.height + margins.top + margins.bottom
        visible: showTimezone

        imagePath: "widgets/background"

        PlasmaComponents.Label {
            id: timezoneText
            x: timezoneBg.margins.left
            y: timezoneBg.margins.top
            text: dataSource.data["Local"]["Timezone"]
            textFormat: Text.PlainText
        }
    }

    Component.onCompleted: {
        tzOffset = new Date().getTimezoneOffset();
        dataSource.onDataChanged.connect(dateTimeChanged);
    }
}
