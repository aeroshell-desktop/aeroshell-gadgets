import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

import io.gitgud.catpswin56.gadgets.slideshow

PlasmoidItem {
    id: root

    // BEGIN GADGET STUFF
    readonly property string plasmoidType: "Gadget"
    readonly property bool resizable: true
    signal requestSizeUpdate()
    // END GADGET STUFF

    readonly property int leftBorder: 4
    readonly property int rightBorder: 6
    readonly property int topBorder: 5
    readonly property int bottomBorder: 5

    Layout.minimumWidth: 130
    Layout.minimumHeight: 100

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    component MediaControl: MouseArea {
        id: ma

        required property string type

        implicitWidth: controlImg.implicitWidth
        implicitHeight: controlImg.implicitHeight

        hoverEnabled: true

        Image {
            id: controlImg

            property string state: {
                if(ma.pressed) return "-pressed";
                if(ma.containsMouse) return "-hover";
                return "";
            }

            anchors.fill: parent

            source: "resources/controls/" + ma.type + state + ".png"
        }
    }

    Slideshow {
        id: slideshow
        running: Plasmoid.configuration.running
        interval: Plasmoid.configuration.interval
        paths: Plasmoid.configuration.paths
    }

    BorderImage {
        id: background

        anchors.fill: parent

        border {
            left: root.leftBorder
            right: root.rightBorder
            top: root.topBorder
            bottom: root.bottomBorder
        }
        source: "resources/background.png"
    }

    Item {
        id: contents

        anchors {
            fill: parent

            leftMargin: root.leftBorder
            rightMargin: root.rightBorder
            topMargin: root.topBorder
            bottomMargin: root.bottomBorder
        }

        Image {
            id: previewer

            anchors.fill: parent

            fillMode: Image.PreserveAspectFit
            mipmap: true
            source: slideshow.currentUrl
        }

        Image {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Kirigami.Units.smallSpacing + 1
            anchors.horizontalCenter: parent.horizontalCenter

            source: "resources/controls/background.png"

            visible: opacity > 0
            opacity: hoverHandler.hovered
            Behavior on opacity {
                NumberAnimation { duration: 125 }
            }

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right

                    verticalCenter: parent.verticalCenter

                    verticalCenterOffset: -1

                    leftMargin: Kirigami.Units.largeSpacing
                    rightMargin: Kirigami.Units.mediumSpacing
                }

                MediaControl {
                    type: "previous"
                    onClicked: slideshow.previous();
                }
                MediaControl {
                    type: slideshow.running ? "pause" : "play"
                    onClicked: slideshow.toggle();
                }
                MediaControl {
                    type: "next"
                    onClicked: slideshow.next();
                }

                Item { implicitWidth: 1 }

                MediaControl {
                    type: "openlocation"
                    onClicked: Qt.openUrlExternally(slideshow.currentUrl);
                }
            }
        }

        HoverHandler {
            id: hoverHandler
            margin: Math.max(Math.max(root.leftBorder, root.rightBorder), Math.max(root.topBorder, root.bottomBorder))
        }
    }
}
