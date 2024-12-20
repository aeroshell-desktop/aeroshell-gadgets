/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 * SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: root

    property alias model: repeater.model
    property var generalModel
    property bool showNightRow: false

    readonly property int preferredIconSize: 27
    readonly property bool hasContent: model && model.length > 0

    spacing: 0

    // Add Day/Night labels as the row headings when there is a night row
    component DayNightLabel: PlasmaComponents.Label {
        visible: root.showNightRow
        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        Layout.fillWidth: true
        Layout.preferredWidth: startsAtNight ? Kirigami.Units.largeSpacing : implicitWidth
        font.bold: true
    }

    DayNightLabel {
        text: i18nc("Time of the day (from the duple Day/Night)", "Day")
    }

    Repeater {
        id: repeater

        delegate: ColumnLayout {
            id: dayDelegate
            width: 45

            RowLayout {
                anchors.fill: parent
                spacing: 0

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true

                        text: modelData?.period?.replace(" nt", "") || ""
                        color: "white"
                        opacity: 0.7
                        font.pointSize: 8
                    }

                    Text {
                        Layout.fillWidth: true

                        text: modelData ? modelData.tempHigh || i18nc("Short for no data available", "-") : ""
                        font.pointSize: 8
                        opacity: 0.7
                        color: "white"
                    }
                    Text {
                        Layout.fillWidth: true

                        text: modelData ? modelData.tempLow || i18nc("Short for no data available", "-") : ""
                        font.pointSize: 8
                        opacity: 0.7
                        color: "white"
                    }
                }

                Kirigami.Icon {
                    Layout.fillWidth: true
                    Layout.preferredWidth: preferredIconSize
                    Layout.preferredHeight: preferredIconSize

                    source: modelData?.icon ?? ""
                }
            }
        }
    }
}
