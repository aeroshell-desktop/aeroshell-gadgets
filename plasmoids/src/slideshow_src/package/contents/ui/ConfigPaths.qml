import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import QtQuick.Dialogs

import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

import org.kde.plasma.plasmoid

KCM.SimpleKCM {
    id: root

    property var cfg_paths: []

    signal configurationChanged()

    Component.onCompleted: {
        cfg_paths = [];

        var list = Plasmoid.configuration.paths;
        for(var i = 0; i < list.length; i++) {
            add(list[i]);
        }
    }

    function add(path) {
        pathsModel.append({ "displayPath": path });
        cfg_paths.push(path);
        configurationChanged();
    }

    function removeAt(index) {
        pathsModel.remove(index);
        cfg_paths.splice(index, 1);
        configurationChanged();
    }

    ListModel { id: pathsModel }

    FolderDialog {
        id: folderDialog

        title: i18n("Choose a folder")
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

        visible: false

        onAccepted: {
            var path = new URL(selectedFolder);
            root.add(path.pathname);
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: -Kirigami.Units.mediumSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            Layout.leftMargin: Kirigami.Units.mediumSpacing
            Layout.rightMargin: Kirigami.Units.mediumSpacing

            spacing: Kirigami.Units.smallSpacing

            QQC2.Button {
                Layout.alignment: Qt.AlignVCenter

                text: i18n("Add")
                onClicked: folderDialog.visible = true;
            }

            QQC2.Button {
                Layout.alignment: Qt.AlignVCenter

                text: i18n("Remove")
                enabled: list.currentIndex != -1
                onClicked: {
                    root.removeAt(list.currentIndex);
                    list.currentIndex -= 1;
                }
            }

            Item { Layout.fillWidth: true }
        }

        Rectangle { Layout.fillWidth: true; Layout.minimumHeight: 1; color: "black"; opacity: 0.25 }

        QQC2.ScrollView {
            id: scrollView

            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: list

                width: parent.width
                height: contentHeight

                model: pathsModel
                delegate: Item {
                    id: delegateRoot

                    required property var model
                    required property int index

                    width: ListView.view.width
                    height: 19

                    KSvg.FrameSvgItem {
                        anchors.fill: parent

                        imagePath: "widgets/viewitem"
                        prefix: ma.containsPress ? "selected" : "hover"

                        visible: ma.containsMouse || list.currentIndex == delegateRoot.index
                    }

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        anchors.rightMargin:4

                        verticalAlignment: Text.AlignVCenter
                        text: delegateRoot.model.displayPath
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onPressed: list.currentIndex = delegateRoot.index
                    }
                }
            }
        }
    }
}
