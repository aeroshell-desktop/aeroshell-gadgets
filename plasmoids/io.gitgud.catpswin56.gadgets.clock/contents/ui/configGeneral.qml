/*
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksvg as KSvg
import org.kde.kcmutils as KCM
import org.kde.plasma.plasmoid

KCM.SimpleKCM {
    property alias cfg_showSecondHand: showSecondHand.checked
    property alias cfg_showTimezoneString: showTimezoneString.checked
    property alias cfg_clockStyle: currentSkin.currentValue

    function basename(str)
    {
        return (str.slice(str.lastIndexOf("/")+1))
    }

    StylesSystem {
        id: systemStyles
        onModelUpdated: {
            currentSkin.currentValue = Plasmoid.configuration.clockStyle.startsWith("clocks/") ? Plasmoid.configuration.clockStyle : systemStyles.associations[basename(Plasmoid.configuration.clockStyle)];
        }
    }

    component CustomGroupBox: GroupBox {
        id: gbox
        label: Label {
            id: lbl
            x: gbox.leftPadding + 2
            y: lbl.implicitHeight/2-gbox.bottomPadding-1
            width: lbl.implicitWidth
            text: gbox.title
            elide: Text.ElideRight
            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: -2
                anchors.rightMargin: -2
                color: Kirigami.Theme.backgroundColor
                z: -1
            }
        }
        background: Rectangle {
            y: gbox.topPadding - gbox.bottomPadding*2
            width: parent.width
            height: parent.height - gbox.topPadding + gbox.bottomPadding*2
            color: "transparent"
            border.color: "#d5dfe5"
            radius: 3
        }
    }

    ColumnLayout {
        CustomGroupBox {
            Layout.fillWidth: true

            title: i18n("General")

            ColumnLayout {
                anchors.fill: parent

                CheckBox {
                    id: showSecondHand
                    text: i18n("Show seconds hand")
                }
                CheckBox {
                    id: showTimezoneString
                    text: i18n("Show timezone")
                }
            }
        }

        CustomGroupBox {
            Layout.fillWidth: true

            title: i18n("Skin")

            ColumnLayout {
                anchors.fill: parent

                KSvg.FrameSvgItem {
                    imagePath: "widgets/background"

                    Layout.preferredWidth: 175
                    Layout.preferredHeight: 175

                    Image {
                        anchors.centerIn: parent

                        source: currentSkin.currentValue + "/preview.png"
                    }
                }

                ComboBox {
                    id: currentSkin
                    Layout.preferredWidth: 175
                    currentValue: Plasmoid.configuration.clockStyle
                    model: systemStyles.styles
                    valueRole: "value"
                    textRole: "text"
                }
            }
        }
    }
}
