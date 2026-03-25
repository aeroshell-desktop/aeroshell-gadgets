/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 * SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>
 * SPDX-FileCopyrightText: 2026 catpswin56 <catpswin56@proton.me>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import QtQuick.Layouts

import org.kde.kirigami as Kirigami

RowLayout {
    id: viewRoot

    property var metaData: null
    property int displayTemperatureUnit: 0
    property var futureDays: null

    spacing: 6

    Repeater {
        id: repeater

        model: viewRoot.futureDays
        delegate: RowLayout {
            id: delegate

            width: 46
            spacing: 7

            visible: model.conditionIcon && (model.index !== 0 && !root.forecast?.currentDay)

            ColumnLayout {
                Layout.fillHeight: true

                spacing: 2
                uniformCellSizes: true

                Text {
                    text: model.highTemp && viewRoot.metaData?.temperatureUnit
                            ? Util.temperatureToDisplayString(viewRoot.displayTemperatureUnit,
                                                              model.highTemp,
                                                              viewRoot.metaData.temperatureUnit,
                                                              true)
                            : i18nc("Short for no data available", "-")
                    color: "white"
                }

                Text {
                    text: model.highTemp && metaData?.temperatureUnit
                            ? Util.temperatureToDisplayString(viewRoot.displayTemperatureUnit,
                                                              model.highTemp,
                                                              viewRoot.metaData.temperatureUnit,
                                                              true)
                            : i18nc("Short for no data available", "-")
                    color: "white"
                    visible: model.highTemp || !repeater.model.isNightPresent
                    opacity: 0.7
                }
                Text {
                    text: model.lowTemp && viewRoot.metaData?.temperatureUnit
                            ? Util.temperatureToDisplayString(viewRoot.displayTemperatureUnit,
                                                              model.lowTemp,
                                                              viewRoot.metaData.temperatureUnit,
                                                              true)
                            : i18nc("Short for no data available", "-")
                    color: "white"
                    visible: model.lowTemp || !repeater.model.isNightPresent
                    opacity: 0.7
                }
            }

            Kirigami.Icon {
                Layout.alignment: Qt.AlignBottom

                Layout.preferredWidth: 27
                Layout.preferredHeight: 27

                source: model.conditionIcon
            }

            Image {
                Layout.bottomMargin: 4

                Layout.fillHeight: true

                source: "sep-vert.png"

                visible: model.index != viewRoot.futureDays.daysNumber - 1
            }
        }
    }
}
