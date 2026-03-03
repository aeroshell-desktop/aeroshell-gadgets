import QtQuick
import QtQml.XmlListModel
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import Qt5Compat.GraphicalEffects

import org.kde.plasma.core as PlasmaCore
import org.kde.ksvg as KSvg
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // BEGIN GADGET STUFF
    readonly property string plasmoidType: "Gadget"
    readonly property bool resizable: false
    signal requestSizeUpdate()
    // END GADGET STUFF

    Layout.preferredWidth: 130
    Layout.preferredHeight: 173

    readonly property var url: Plasmoid.configuration.url

    Plasmoid.backgroundHints: "NoBackground"

    KSvg.FrameSvgItem {
        anchors.fill: bg
        anchors.margins: -Kirigami.Units.smallSpacing

        imagePath: "dialogs/background"

        visible: moreFlyout.visible
    }

    function stripString (str) {
        var regex = /(<img.*?>)/gi;
        str = str.replace(regex, "");
        regex = /&#228;/gi;
        str = str.replace(regex, "ä");
        regex = /&#246;/gi;
        str = str.replace(regex, "ö");
        regex = /&#252;/gi;
        str = str.replace(regex, "ü");
        regex = /&#196;/gi;
        str = str.replace(regex, "Ä");
        regex = /&#214;/gi;
        str = str.replace(regex, "Ö");
        regex = /&#220;/gi;
        str = str.replace(regex, "Ü");
        regex = /&#223;/gi;
        str = str.replace(regex, "ß");

        return str;
    }

    XmlListModel {
        id: xmlModel

        source: url
        query: "/rss/channel/item"

        onStatusChanged: {
            list.visible = false
            if(!noFeed.visible) busyIndicator.visible = true
        }

        XmlListModelRole { name: "title"; elementName: "title" }
        XmlListModelRole { name: "pubDate"; elementName: "pubDate" }
        XmlListModelRole { name: "link"; elementName: "link" }
        XmlListModelRole { name: "content"; elementName: "encoded" }
        XmlListModelRole { name: "description"; elementName: "description" }
        XmlListModelRole { name: "creator"; elementName: "creator" }
    }

    Image {
        id: bg

        anchors.centerIn: parent

        source: "resources/unexpanded/background.png"
    }

    Component {
        id: feedDelegate

        Item {
            width: 123
            height: 35

            Component.onCompleted: {
                list.visible = true
                busyIndicator.visible = false
            }

            Image {
                id: delegateSelected
                source: "resources/unexpanded/selected.png"
                visible: moreFlyout.visible && moreFlyout.itemIndex == index ? true : false
            }

            ColumnLayout {
                id: layout

                anchors {
                    fill: parent
                    rightMargin: Kirigami.Units.smallSpacing*2
                    leftMargin: Kirigami.Units.smallSpacing*2
                }

                spacing: -Kirigami.Units.smallSpacing

                Item { Layout.fillHeight: true }

                Text {
                    id: titleText

                    Layout.fillWidth: true

                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.NoWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    color: "white"
                    text: title
                    renderType: Text.NativeRendering
                    font.hintingPreference: Font.PreferFullHinting
                    font.kerning: false
                    font.bold: true
                }

                Item { Layout.preferredHeight: Kirigami.Units.smallSpacing*2 }

                RowLayout {
                    Text {
                        id: linkText

                        Layout.fillWidth: true

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "white"
                        text: creator
                        renderType: Text.NativeRendering
                        font.hintingPreference: Font.PreferFullHinting
                        font.kerning: false
                        font.pointSize: 8

                        opacity: 0.3
                    }
                    Text {
                        id: dateText

                        Layout.fillWidth: true

                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: "white"
                        text: pubDate
                        renderType: Text.NativeRendering
                        font.hintingPreference: Font.PreferFullHinting
                        font.kerning: false
                        font.pointSize: 8

                        opacity: 0.3
                    }
                }

                Item { Layout.fillHeight: true }
            }

            Rectangle {
                anchors {
                    right: parent.right
                    left: parent.left
                    leftMargin: -Kirigami.Units.smallSpacing*3
                    bottom: parent.bottom
                }

                height: 1

                color: "white"

                opacity: 0.2
            }

            MouseArea {
                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    moreFlyout.itemIndex = index // to identify which item should have the selected state
                    moreFlyout.title = title
                    moreFlyout.link = link
                    moreFlyout.creator = creator

                    if(content == "") {
                        moreFlyout.content = description
                    } else moreFlyout.content = content

                    if(moreFlyout.visible) {
                        moreFlyout.visible = false
                    } else {
                        moreFlyout.visible = true
                    }
                }
            }
        }
    }

    Text {
        id: noFeed

        anchors {
            right: bg.right
            left: bg.left

            verticalCenter: bg.verticalCenter
            verticalCenterOffset: -Kirigami.Units.smallSpacing * 4
        }

        text: "No feed items to display."
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        rightPadding: Kirigami.Units.smallSpacing * 2
        leftPadding: rightPadding

        visible: url == ""
    }

    Item {
        id: bottomControls

        anchors {
            bottom: bg.bottom
            bottomMargin: Kirigami.Units.smallSpacing

            horizontalCenter: bg.horizontalCenter
        }

        width: 121
        height: 26

        Rectangle {
            id: bCBg

            anchors.centerIn: parent

            width: 78
            height: 20

            color: "black"

            border.width: 1
            border.color: "white"
            radius: 12

            opacity: 0.2
        }

        RowLayout {
            anchors.fill: bCBg
            anchors.rightMargin: Kirigami.Units.smallSpacing/2
            anchors.leftMargin: Kirigami.Units.smallSpacing/2

            Image {
                id: downButton

                property string suffix: downButtonMa.containsMouse ? "-hover.png" : ".png"

                source: "resources/controls/down" + suffix

                opacity: list.atYEnd ? 0.5 : 1

                MouseArea {
                    id: downButtonMa

                    anchors.fill: parent

                    visible: !list.atYEnd

                    hoverEnabled: true

                    onClicked: {
                        if(list.currentIndex == list.count) {
                            return;
                        } else {
                            list.currentIndex += 3;
                            if(list.currentIndex > list.count) list.currentIndex = list.count;
                            list.positionViewAtIndex(list.currentIndex, ListView.SnapPosition);
                        }

                    }
                }
            }

            Text {
                id: itemCount

                Layout.fillWidth: true

                color: "white"
                text: list.currentIndex + " - " + list.count
                renderType: Text.NativeRendering
                font.hintingPreference: Font.PreferFullHinting
                font.kerning: false

                horizontalAlignment: Text.AlignHCenter
            }

            Image {
                id: upButton

                property string suffix: upButtonMa.containsMouse ? "-hover.png" : ".png"

                source: "resources/controls/up" + suffix

                opacity: list.count > 3 && list.currentIndex > 0 ? 1 : 0.5

                MouseArea {
                    id: upButtonMa

                    anchors.fill: parent

                    visible: list.count > 3 && list.currentIndex > 0

                    hoverEnabled: true

                    onClicked: {
                        if(list.currentIndex == 0) {
                            return;
                        } else {
                            list.currentIndex -= 3;
                            if(list.currentIndex < 0) list.currentIndex = 0;
                            list.positionViewAtIndex(list.currentIndex, ListView.SnapPosition);
                        }
                    }
                }
            }
        }

        visible: list.count != 0
    }

    ListView {
        id: list

        anchors {
            fill: bg

            topMargin: Kirigami.Units.smallSpacing - 1
            bottomMargin: bottomControls.height + (Kirigami.Units.smallSpacing * 2)
            // rightMargin: Kirigami.Units.smallSpacing*2
            leftMargin: Kirigami.Units.smallSpacing - 1
        }

        clip: true
        interactive: false
        spacing: 0
        model: xmlModel
        delegate: feedDelegate
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds
    }

    // TODO: remove this once item sizes are fixed
    Rectangle {
        id: fadeGradient

        anchors {
            bottom: bottomControls.top
            right: list.right
            left: list.left

            bottomMargin: Kirigami.Units.smallSpacing / 2
            rightMargin: Kirigami.Units.smallSpacing + 1
            leftMargin: 1
        }

        height: 35

        gradient: Gradient {
            GradientStop { position: 1.0; color: "black" }
            GradientStop { position: 0.0; color: "transparent" }
        }

        opacity: 0.6

        visible: !list.atYEnd
    }

    Image  {
        id: busyIndicator

        property int frameNumber: 0

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -Kirigami.Units.smallSpacing*2

        source: "resources/loading-circle/" + frameNumber

        visible: false

        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            NumberAnimation { target: busyIndicator; property: "frameNumber"; to: 17; duration: 900 }
            NumberAnimation { target: busyIndicator; property: "frameNumber"; to: 0; duration: 0 }
        }
    }

    Flyout {
        id: moreFlyout

        visualParent: bg

        mainItem: KSvg.FrameSvgItem {
            width: flyoutBg.width + Kirigami.Units.smallSpacing*2
            height: flyoutBg.height + Kirigami.Units.smallSpacing*2

            imagePath: "dialogs/background"

            Image {
                id: flyoutBg

                anchors.centerIn: parent

                source: "resources/flyoutBg.png"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing

                    spacing: 0

                    ColumnLayout {
                        Layout.leftMargin: Kirigami.Units.smallSpacing*2
                        Layout.preferredHeight: 28

                        spacing: -4

                        Text {
                            Layout.preferredWidth: 280

                            text: moreFlyout.title
                            color: "white"
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
                            maximumLineCount: 1
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 10
                            font.bold: true

                            renderType: Text.NativeRendering
                            font.hintingPreference: Font.PreferFullHinting
                            font.kerning: false
                        }
                        Text {
                            Layout.preferredWidth: 280

                            text: moreFlyout.creator
                            color: "white"
                            elide: Text.ElideRight
                            wrapMode: Text.NoWrap
                            maximumLineCount: 1
                            verticalAlignment: Text.AlignVCenter
                            font.pointSize: 8

                            renderType: Text.NativeRendering
                            font.hintingPreference: Font.PreferFullHinting
                            font.kerning: false
                        }
                    }
                    QQC2.ScrollView {
                        Layout.leftMargin: Kirigami.Units.smallSpacing
                        Layout.rightMargin: Kirigami.Units.smallSpacing
                        Layout.preferredHeight: 173
                        Layout.preferredWidth: 288

                        ColumnLayout {
                            width: 286

                            Text {
                                text: "Open link in browser"
                                color: "#2e6998"

                                renderType: Text.NativeRendering
                                font.hintingPreference: Font.PreferFullHinting
                                font.kerning: false
                                font.underline: linkMa.containsMouse

                                MouseArea {
                                    id: linkMa

                                    anchors.fill: parent

                                    hoverEnabled: true

                                    onClicked: Qt.openUrlExternally(moreFlyout.link)
                                }
                            }

                            Text {
                                Layout.preferredWidth: 250

                                text: moreFlyout.content
                                wrapMode: Text.WordWrap

                                renderType: Text.NativeRendering
                                font.hintingPreference: Font.PreferFullHinting
                                font.kerning: false
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 300000
        running: true
        repeat: true
        onTriggered: { xmlModel.reload() }
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Refresh")
            icon.name: "view-refresh"
            onTriggered: xmlModel.reload()
        }
    ]
}
