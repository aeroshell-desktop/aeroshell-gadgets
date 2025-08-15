import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_enableMarkdown: enableMarkdown.checked
    property alias cfg_sizeMode: sizeMode.currentIndex

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

        CustomGroupBox {
            Layout.fillWidth: true

            title: i18n("Formatting")

            ColumnLayout {
                Column {
                    spacing: 4

                    QQC2.CheckBox {
                        id: enableMarkdown
                        text: i18n("Use Markdown")
                    }

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 17

                        spacing: 4

                        Kirigami.Icon {
                            implicitWidth: 16
                            implicitHeight: width

                            source: "dialog-information"
                        }

                        Text {
                            text: i18n("\"Click to Edit\" behavior will be used for editing text")
                        }

                        visible: enableMarkdown.checked
                    }
                }
            }
        }

        CustomGroupBox {
            Layout.fillWidth: true

            title: i18n("Miscellaneous")

            RowLayout {
                Text {
                    text: i18n("Size:")
                }
                QQC2.ComboBox {
                    id: sizeMode
                    model: [
                        i18n("Normal"),
                        i18n("Expanded"),
                        i18n("Resizable")
                    ]
                }
            }
        }
    }
}
