import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Effects

import Qt.labs.platform as Platform

import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_hue: hue.value
    property alias cfg_saturation: saturation.value
    property alias cfg_lightness: lightness.value

    property alias cfg_fontFamily: fontDialog.fontChosen.family
    property alias cfg_fontStyle: fontDialog.fontChosen.styleName
    property alias cfg_fontPointSize: fontDialog.fontChosen.pointSize

    property color noteColor: Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)

    property color textColor: {
        var yiq_y = ((noteColor.r * 0.299) + (noteColor.g * 0.587) + (noteColor.b * 0.114));
        return yiq_y >= 0.5 ? "black" : "white"
    }

    component CustomGroupBox: QQC2.GroupBox {
        id: gbox
        label: QQC2.Label {
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
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
            Layout.alignment: Qt.AlignHCenter

            source: "../../assets/note-normal.png"

            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 0.8
                colorizationColor: noteColor
            }

            Item {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -4
                anchors.horizontalCenterOffset: -1

                width: 112
                height: 90

                TextEdit {
                    id: textEdit

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                    }

                    height: 68

                    font.family: root.cfg_fontFamily
                    font.styleName: root.cfg_fontStyle
                    font.pointSize: root.cfg_fontPointSize
                    leftPadding: 4
                    rightPadding: 4
                    wrapMode: Text.Wrap
                    text: i18n("Example text")
                    textFormat: Text.PlainText
                    color: root.textColor
                    readOnly: true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            uniformCellSizes: true

            CustomGroupBox {
                Layout.fillWidth: true

                title: i18n("Color")

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Hue:")
                        }

                        QQC2.Slider {
                            id: hue

                            Layout.fillWidth: true

                            from: 0
                            to: 360

                            background: Rectangle {
                                x: hue.leftPadding
                                y: hue.topPadding + hue.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: hue.availableWidth
                                height: hue.availableHeight

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 6
                                    anchors.bottomMargin: 6

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal

                                        GradientStop { position: 0; color: "#FF0000" }
                                        GradientStop { position: 0.167; color: "#FFFF00" }
                                        GradientStop { position: 0.33; color: "#00FF00" }
                                        GradientStop { position: 0.5; color: "#00FFFF" }
                                        GradientStop { position: 0.667; color: "#0000FF" }
                                        GradientStop { position: 0.833; color: "#FF00FF" }
                                        GradientStop { position: 1; color: "#FF0000" }
                                    }
                                }
                            }

                            handle: BorderImage {
                                property string state: {
                                    if(hue.pressed) return "-pressed"
                                        else if(hue.hovered) return "-hover"
                                            else return "-normal"
                                }

                                x: hue.leftPadding + hue.visualPosition * (hue.availableWidth - width)
                                y: hue.topPadding + hue.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"
                            }

                            onValueChanged: noteColor = Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)
                        }
                    }

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Saturation:")
                        }

                        QQC2.Slider {
                            id: saturation

                            Layout.fillWidth: true

                            from: 0
                            to: 100

                            background: Rectangle {
                                x: hue.leftPadding
                                y: hue.topPadding + hue.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: hue.availableWidth
                                height: hue.availableHeight

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 6
                                    anchors.bottomMargin: 6

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal

                                        GradientStop { position: 0; color: Qt.hsla(hue.value/360, 0, lightness.value/100, 1.0) }
                                        GradientStop { position: 1; color: Qt.hsla(hue.value/360, 1.0, lightness.value/100, 1.0) }
                                    }
                                }
                            }

                            handle: BorderImage {
                                property string state: {
                                    if(saturation.pressed) return "-pressed"
                                        else if(saturation.hovered) return "-hover"
                                            else return "-normal"
                                }

                                x: saturation.leftPadding + saturation.visualPosition * (saturation.availableWidth - width)
                                y: saturation.topPadding + saturation.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"
                            }

                            onValueChanged: noteColor = Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)
                        }
                    }

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Lightness:")
                        }

                        QQC2.Slider {
                            id: lightness

                            Layout.fillWidth: true

                            from: 0
                            to: 100

                            background: Rectangle {
                                x: lightness.leftPadding
                                y: lightness.topPadding + lightness.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: lightness.availableWidth
                                height: lightness.availableHeight

                                color: "transparent"

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 6
                                    anchors.bottomMargin: 6

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal

                                        GradientStop { position: 0; color: Qt.hsla(hue.value/360, saturation.value/100, 0, 1.0) }
                                        GradientStop { position: 1; color: Qt.hsla(hue.value/360, saturation.value/100, 1.0, 1.0) }
                                    }
                                }
                            }

                            handle: BorderImage {
                                property string state: {
                                    if(lightness.pressed) return "-pressed"
                                        else if(lightness.hovered) return "-hover"
                                            else return "-normal"
                                }

                                x: lightness.leftPadding + lightness.visualPosition * (lightness.availableWidth - width)
                                y: lightness.topPadding + lightness.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"
                            }

                            onValueChanged: noteColor = Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)
                        }
                    }
                }
            }

            CustomGroupBox {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true

                title: i18n("Font")

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    RowLayout {
                        Column {
                            Layout.fillWidth: true

                            Text {
                                text: i18n("Current font:")
                            }
                            Text {
                                text: fontDialog.fontChosen.family + " " + fontDialog.fontChosen.styleName
                            }
                        }

                        QQC2.Button {
                            Layout.minimumWidth: 85
                            Layout.maximumWidth: 85

                            text: i18n("Change...")
                            onClicked: {
                                fontDialog.currentFont = fontDialog.fontChosen
                                fontDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }

    Platform.FontDialog {
        id: fontDialog

        property font fontChosen: null

        title: i18n("Choose a Font")
        modality: Qt.WindowModal
        parentWindow: root.Window.window

        onAccepted: fontChosen = font
    }
}
