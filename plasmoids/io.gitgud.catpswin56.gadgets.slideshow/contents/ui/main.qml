/*
 *  SPDX-FileCopyrightText: 2015 Lars Pontoppidan <dev.larpon@gmail.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.draganddrop 2.0 as DragDrop

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kquickcontrolsaddons 2.0

import org.kde.plasma.private.mediaframe 2.0

PlasmoidItem {
    id: main

    MediaFrame {
        id: items
        random: plasmoid.configuration.randomize
    }

    preferredRepresentation: fullRepresentation

    switchWidth: 130
    switchHeight: 100

    Plasmoid.backgroundHints: "NoBackground"

    width: 130
    height: 100

    property string activeSource: ""
    property string transitionSource: ""

    property bool pause: !nextTimer.running

    readonly property int itemCount: (items.count + items.futureLength)
    readonly property bool hasItems: ((itemCount > 0) || (items.futureLength > 0))
    readonly property bool isTransitioning: faderAnimation.running

    onActiveSourceChanged: {
        items.watch(activeSource)
    }

    onHasItemsChanged: {
        if(hasItems) {
            if(activeSource == "")
                nextItem()
        }
    }

    onExternalData: (mimetype, data) => {
        var type = items.isDir(data) ? "folder" : "file";
        var item = {
            "path": data,
            "type": type
        };

        addItem(item);
    }

    function loadPathList() {
        var list = plasmoid.configuration.pathList
        items.clear()
        for(var i in list) {
            var item = JSON.parse(list[i])
            items.add(item.path,true)
        }
    }

    Component.onCompleted: {
        loadPathList()

        if (items.random)
            nextItem()
    }

    Connections {
        target: plasmoid.configuration
        function onPathListChanged() {
            loadPathList()
        }
    }

    function addItem(item) {

        if(items.isAdded(item.path)) {
            console.info(item.path,"already exists. Skipping…")
            return
        }
        // work-around for QTBUG-67773:
        // C++ object property of type QVariant(QStringList) is not updated on changes from QML
        // so explicitly create a deep JSValue copy, modify that and then set it back to overwrite the old
        var updatedList = plasmoid.configuration.pathList.slice();
        updatedList.push(JSON.stringify(item));
        plasmoid.configuration.pathList = updatedList;
    }

    function nextItem() {

        if(!hasItems) {
            console.warn("No items available")
            return
        }

        var active = activeSource

        // Only record history if we have more than one item
        if(itemCount > 1)
            items.pushHistory(active)

        if(items.futureLength > 0) {
            setActiveSource(items.popFuture())
        } else {
            //setLoading()
            items.get(function(filePath){
                setActiveSource(filePath)
                //unsetLoading()
            },function(errorMessage){
                //unsetLoading()
                console.error("Error while getting next image",errorMessage)
            })
        }
    }

    function previousItem() {
        var active = activeSource
        items.pushFuture(active)
        var filePath = items.popHistory()
        setActiveSource(filePath)
    }

    Connections {
        target: items

        function onItemChanged(path) {
            console.log("item",path,"changed")
            activeSource = ""
            setActiveSource(path)
        }

    }

    Timer {
        id: nextTimer
        interval: (plasmoid.configuration.interval*1000)
        repeat: true
        running: hasItems && !pause
        onTriggered: nextItem()
    }

    Image {
        id: itemView

        anchors.centerIn: parent

        source: "resources/unexpanded/bg.png"

        Item {
            id: imageView
            visible: hasItems
            anchors {
                fill: parent
                leftMargin: Kirigami.Units.smallSpacing
                rightMargin: Kirigami.Units.smallSpacing + Kirigami.Units.smallSpacing/2
                topMargin: Kirigami.Units.smallSpacing + Kirigami.Units.smallSpacing/4
                bottomMargin: Kirigami.Units.smallSpacing + Kirigami.Units.smallSpacing/4
            }

            PlasmaComponents3.Button {
                anchors.centerIn: parent

                visible: !hasItems
                icon.name: "configure"
                text: i18nc("@action:button", "Configure…")
                onClicked: {
                    Plasmoid.internalAction("configure").trigger();
                }
            }

            MouseArea {
                id: imageViewMa

                anchors.fill: parent

                hoverEnabled: true
                propagateComposedEvents: true
                preventStealing: false

                Item {
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: Kirigami.Units.smallSpacing

                        horizontalCenter: parent.horizontalCenter
                    }

                    opacity: imageViewMa.containsMouse

                    Behavior on opacity {
                        NumberAnimation { duration: 250 }
                    }

                    visible: opacity

                    height: 22
                    width: 111

                    Rectangle {
                        anchors.fill: parent

                        color: "#1f3043"

                        border.width: 1
                        border.color: "white"
                        radius: 12

                        opacity: 0.5
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.rightMargin: Kirigami.Units.smallSpacing
                        anchors.leftMargin: Kirigami.Units.smallSpacing
                        spacing: Kirigami.Units.smallSpacing

                        Image {
                            property string suffix: previousBtnMa.containsMouse ? (previousBtnMa.containsPress ? "-pressed" : "-hover") : ""

                            source: "resources/controls/previous" + suffix + ".png"

                            MouseArea {
                                id: previousBtnMa

                                anchors.fill: parent

                                hoverEnabled: true
                                propagateComposedEvents: true
                                preventStealing: false

                                onClicked: main.previousItem()
                            }
                        }
                        Image {
                            property string playState: nextTimer.running ? "pause" : "play"
                            property string suffix: slideshowBtnMa.containsMouse ? (slideshowBtnMa.containsPress ? "-pressed" : "-hover") : ""

                            source: "resources/controls/" + playState + suffix + ".png"

                            MouseArea {
                                id: slideshowBtnMa

                                anchors.fill: parent

                                hoverEnabled: true
                                propagateComposedEvents: true
                                preventStealing: false

                                onClicked: nextTimer.running ? (nextTimer.running = false) : (nextTimer.running = true)
                            }
                        }
                        Image {
                            property string suffix: nextBtnMa.containsMouse ? (nextBtnMa.containsPress ? "-pressed" : "-hover") : ""

                            source: "resources/controls/next" + suffix + ".png"

                            MouseArea {
                                id: nextBtnMa

                                anchors.fill: parent

                                hoverEnabled: true
                                propagateComposedEvents: true
                                preventStealing: false

                                onClicked: main.nextItem()
                            }
                        }

                        Rectangle {
                            Layout.preferredWidth: 1
                            Layout.preferredHeight: 11

                            color: "white"

                            opacity: 0.5
                        }

                        Image {
                            property string suffix: openlocationBtnMa.containsMouse ? (openlocationBtnMa.containsPress ? "-pressed" : "-hover") : ""

                            source: "resources/controls/openlocation" + suffix + ".png"

                            MouseArea {
                                id: openlocationBtnMa

                                anchors.fill: parent

                                hoverEnabled: true
                                propagateComposedEvents: true
                                preventStealing: false

                                onClicked: Qt.openUrlExternally(main.activeSource)
                            }
                        }
                    }
                }

                z: 1
            }

            // This timer prevents reloading the image too often when resizing,
            // to minimize excessively re-reading the file on disk
            Timer {
                id: imageReloadTimer
                interval: 250
                running: false
                onTriggered: {
                    frontImage.sourceSize.width = width
                    frontImage.sourceSize.height = height
                }
            }

            Image {
                id: bufferImage


                anchors.fill: parent
                fillMode: plasmoid.configuration.fillMode

                opacity: 0

                cache: false
                source: transitionSource

                asynchronous: true
                autoTransform: true
            }

            Image {
                id: frontImage

                anchors.fill: parent
                fillMode: plasmoid.configuration.fillMode

                cache: false
                source: activeSource

                asynchronous: true
                autoTransform: true

                onWidthChanged: imageReloadTimer.restart()
                onHeightChanged: imageReloadTimer.restart()

                sourceSize.width: width
                sourceSize.height: height
            }
        }

    }

    function setActiveSource(source) {
        if(itemCount > 1) { // Only do transition if we have more that one item
            transitionSource = source
            faderAnimation.restart()
        } else {
            transitionSource = source
            activeSource = source
        }
    }

    SequentialAnimation {
        id: faderAnimation

        ParallelAnimation {
            OpacityAnimator { target: frontImage; from: 1; to: 0; duration: Kirigami.Units.veryLongDuration }
            OpacityAnimator { target: bufferImage; from: 0; to: 1; duration: Kirigami.Units.veryLongDuration }
        }
        ScriptAction {
            script: {
                // Copy the transitionSource
                var ts = transitionSource
                activeSource = ts
                frontImage.opacity = 1
                transitionSource = ""
                bufferImage.opacity = 0
            }
        }
    }
}
