/*
    SPDX-FileCopyrightText: 2012 Viranch Mehta <viranch.mehta@gmail.com>
    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>
    SPDX-FileCopyrightText: 2025 catpswin56 <catpswin5@proton.me>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtCore

import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as P5Support
import org.kde.plasma.clock

PlasmoidItem {
    id: analogclock

    // BEGIN GADGET STUFF
    readonly property string plasmoidType: "Gadget"
    readonly property bool resizable: false
    signal requestSizeUpdate()
    // END GADGET STUFF

    Layout.minimumWidth: 124
    Layout.minimumHeight: 124
    Layout.maximumWidth: 124
    Layout.maximumHeight: 124

    Clock {
        id: plasmaClock
        trackSeconds: Plasmoid.configuration.showSecondHand
    }

    readonly property string currentTime: Qt.locale().toString(plasmaClock.dateTime, Qt.locale().timeFormat(Locale.LongFormat))
    readonly property string currentDate: Qt.locale().toString(plasmaClock.dateTime, Qt.locale().dateFormat(Locale.LongFormat).replace(/(^dddd.?\s)|(,?\sdddd$)/, ""))

    onCurrentTimeChanged: {
        var date = plasmaClock.dateTime;
        hours = date.getHours();
        minutes = date.getMinutes();
        seconds = date.getSeconds();
    }

    property int hours
    property int minutes
    property int seconds
    property bool showSecondsHand: Plasmoid.configuration.showSecondHand
    property bool showTimezone: Plasmoid.configuration.showTimezoneString
    property int tzOffset

    property string themePath: Plasmoid.configuration.clockStyle

    Plasmoid.backgroundHints: "NoBackground";

    Accessible.name: Plasmoid.title
    Accessible.description: i18nc("@info:tooltip", "Current time is %1; Current date is %2", analogclock.currentTime, analogclock.currentDate)
    Accessible.role: Accessible.Button

    function basename(str)
    {
        return (str.slice(str.lastIndexOf("/")+1))
    }


    KSvg.FrameSvgItem {
        id: errorMessage

        anchors.fill: parent
        visible: face.status == Image.Error

        imagePath: "widgets/background"

        PlasmaComponents.Label {
            id: errorText
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            wrapMode: Text.Wrap
            text: i18n("Failed to load theme %1 properly!", basename(themePath))
            textFormat: Text.PlainText
        }
        z: 99
    }

    Item {
        id: clock

        anchors.fill: parent

        Image {
            id: face
            anchors.centerIn: parent
            source: themePath.startsWith("clocks/") ? themePath + "/clock.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/clock.png")
        }

        Hand {
            id: hourHand
            rotation: 180 + hours * 30 + (minutes/2)
            source: themePath.startsWith("clocks/") ? themePath + "/hour.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/hour.png")
        }

        Hand {
            id: minuteHand
            rotation: 180 + minutes * 6
            source: themePath.startsWith("clocks/") ? themePath + "/minute.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/minute.png")
        }

        Hand {
            id: secondHand
            visible: showSecondsHand
            rotation: 180 + seconds * 6
            source: themePath.startsWith("clocks/") ? themePath + "/second.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/second.png")
        }

        Image {
            anchors.centerIn: face
            source: themePath.startsWith("clocks/") ? themePath + "/pin.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/pin.png")
        }

        Image {
            anchors.centerIn: face
            source: themePath.startsWith("clocks/") ? themePath + "/shine.png" :
                    StandardPaths.locate(StandardPaths.GenericDataLocation, "win-gadgets/clockfaces/"+basename(themePath)+"/shine.png")
            visible: status == Image.Ready
        }
    }

    KSvg.FrameSvgItem {
        id: timezoneBg

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.bottom
        }
        width: childrenRect.width + margins.right + margins.left
        height: childrenRect.height + margins.top + margins.bottom
        visible: showTimezone

        imagePath: "widgets/background"

        PlasmaComponents.Label {
            id: timezoneText
            x: timezoneBg.margins.left
            y: timezoneBg.margins.top
            text: plasmaClock.timeZoneName
            textFormat: Text.PlainText
        }
    }
}
