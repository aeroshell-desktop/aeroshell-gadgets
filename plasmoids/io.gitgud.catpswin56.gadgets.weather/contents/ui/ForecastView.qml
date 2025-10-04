/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 * SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>
 * SPDX-FileCopyrightText: 2025 catpswin56 <>
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

    spacing: 8

    Repeater {
        id: repeater

        delegate: RowLayout {
            id: delegate

            width: 46

            spacing: 7

            ColumnLayout {
                Layout.fillHeight: true

                spacing: 2
                uniformCellSizes: true

                opacity: 0.7

                Text {
                    text: modelData?.period?.replace(" nt", "") || ""
                    color: "white"
                }

                Text {
                    text: modelData ? modelData.tempHigh || i18nc("Short for no data available", "-") : ""
                    color: "white"
                }
                Text {
                    text: modelData ? modelData.tempLow || i18nc("Short for no data available", "-") : ""
                    color: "white"
                }
            }

            Kirigami.Icon {
                Layout.alignment: Qt.AlignBottom

                Layout.preferredWidth: 27
                Layout.preferredHeight: 27

                source: modelData?.icon ?? ""
            }

            Image {
                Layout.bottomMargin: 4

                Layout.fillHeight: true

                source: "resources/sep-vert.png"

                visible: model.index != repeater.count - 1
            }
        }
    }
}
