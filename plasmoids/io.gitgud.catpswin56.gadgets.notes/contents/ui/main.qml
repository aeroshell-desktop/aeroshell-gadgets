import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Effects
import QtCore

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.extras as PlasmaExtras

PlasmoidItem {
    id: root

    // BEGIN GADGET STUFF
    readonly property string plasmoidType: "Gadget"
    readonly property bool resizable: Plasmoid.configuration.sizeMode === 2
    signal requestSizeUpdate()

    Connections {
        target: Plasmoid.configuration

        function onSizeModeChanged() { root.requestSizeUpdate(); }
    }
    // END GADGET STUFF

    readonly property color noteColor: Qt.hsla(Plasmoid.configuration.hue/360,
                                               Plasmoid.configuration.saturation/100,
                                               Plasmoid.configuration.lightness/100, 1.0)

    readonly property color textColor: Qt.hsla(Plasmoid.configuration.fontHue/360,
                                               Plasmoid.configuration.fontSaturation/100,
                                               Plasmoid.configuration.fontLightness/100, 1.0)

    readonly property color autoTextColor: {
        var yiq_y = ((noteColor.r * 0.299) + (noteColor.g * 0.587) + (noteColor.b * 0.114));
        return yiq_y >= 0.5 ? "black" : "white"
    }

    states: [
        State {
            when: Plasmoid.configuration.sizeMode !== 2

            PropertyChanges {
                target: root

                Layout.minimumWidth: note.width
                Layout.minimumHeight: note.height
            }

        }
    ]

    Layout.minimumWidth: note.width
    Layout.minimumHeight: note.height

    expandedOnDragHover: true

    Plasmoid.backgroundHints: "NoBackground"

    component CircleButton: MouseArea {
        id: controlRoot

        property string state: {
            if(enabled) {
                if(containsPress) return "-pressed"
                else if(containsMouse) return "-hover"
                else return "-normal"
            } else return "-disabled"
        }

        property string controlType

        implicitWidth: 16
        implicitHeight: implicitWidth

        hoverEnabled: true

        Image {
            anchors.fill: parent

            source: "../assets/controls/" + controlRoot.controlType + controlRoot.state + ".png"
        }
    }

    HoverHandler { id: hoverHandler }

    Item {
        id: notesManager

        property var notes
        property int count: 0
        property int currentIndex: -1

        function setText(newText: string) {
            notes[currentIndex].text = newText;
            save();
        }

        function addNote() {
            var newNote = {"text":""};
            notes.push(newNote);
            currentIndex += notes.length-1;
            save();
        }

        function deleteNote() {
            notes.splice(currentIndex, 1);
            save();
            textEdit.clear();
            textEdit.insert(0, notes[currentIndex].text);

        }

        function save() {
            Plasmoid.configuration.notes = JSON.stringify(notes);
            Plasmoid.configuration.writeConfig();
            count = notes.length;
        }

        onCountChanged: if((currentIndex+1) > count) currentIndex = (count-1)
        onCurrentIndexChanged: textEdit.text = notes[currentIndex].text;

        Component.onCompleted: {
            notes = JSON.parse(Plasmoid.configuration.notes);

            count = notes.length;
            currentIndex = 0;
        }
    }

    Image {
        id: note

        anchors.centerIn: parent

        readonly property string color: {
            switch(Plasmoid.configuration.preset) {
                case 0:
                    return "yellow-";
                case 1:
                    return "purple-";
                case 2:
                    return "green-";
                case 3:
                    return "pink-";
                case 4:
                    return "blue-";
                default:
                    return "white-";
            }
        }

        source: (Plasmoid.configuration.sizeMode !== 1) ? "../assets/notes/" + color + "normal.png" : "../assets/notes/" + color + "expanded.png"

        visible: Plasmoid.configuration.sizeMode !== 2
        layer.enabled: Plasmoid.configuration.preset == 6
        layer.effect: MultiEffect {
            colorization: 0.8
            colorizationColor: root.noteColor
        }

    }
    BorderImage {
        id: noteResizable

        width: root.width
        height: root.height

        border {
            left: 11
            right: 17
            top: 9
            bottom: 20
        }
        source: "../assets/notes/" + note.color + "expanded.png"

        visible: Plasmoid.configuration.sizeMode === 2
        layer.enabled: Plasmoid.configuration.preset == 6
        layer.effect: MultiEffect {
            colorization: 0.8
            colorizationColor: root.noteColor
        }
    }

    Item {
        id: contentArea

        anchors {
            leftMargin: (Plasmoid.configuration.sizeMode === 2) ? 15 : 0
            rightMargin: (Plasmoid.configuration.sizeMode === 2) ? 16 : 0
            topMargin: (Plasmoid.configuration.sizeMode === 2) ? 8 : 0
            bottomMargin: (Plasmoid.configuration.sizeMode === 2) ? 20 : 0

            verticalCenterOffset: (Plasmoid.configuration.sizeMode !== 0) ? -6 : -4
            horizontalCenterOffset: (Plasmoid.configuration.sizeMode !== 0) ? -3 : -1
        }

        states: [
            State {
                when: Plasmoid.configuration.sizeMode === 2

                AnchorChanges {
                    target: contentArea

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                }
            },
            State {
                when: Plasmoid.configuration.sizeMode !== 2

                AnchorChanges {
                    target: contentArea

                    anchors.horizontalCenter: note.horizontalCenter
                    anchors.verticalCenter: note.verticalCenter
                }
                PropertyChanges {
                    target: contentArea

                    width: (Plasmoid.configuration.sizeMode !== 0) ? 170 : 112
                    height: (Plasmoid.configuration.sizeMode !== 0) ? 149 : 90
                }
            }
        ]

        PlasmaExtras.Menu {
            id: contextMenu

            visualParent: textEdit

            PlasmaExtras.MenuItem {
                enabled: textEdit.selectedText.length > 0 && !textEdit.readOnly
                text: i18n("Cut")
                icon: "edit-cut"
                onClicked: textEdit.cut();
            }

            PlasmaExtras.MenuItem {
                enabled: textEdit.selectedText.length > 0
                text: i18n("Copy")
                icon: "edit-copy"
                onClicked: textEdit.copy();
            }

            PlasmaExtras.MenuItem {
                enabled: textEdit.canPaste && !textEdit.readOnly
                text: i18n("Paste")
                icon: "edit-paste"
                onClicked: {
                    textEdit.paste();
                    scrollArea.scrollToCursor();
                }
            }

            PlasmaExtras.MenuItem { separator: true }

            PlasmaExtras.MenuItem {
                enabled: textEdit.canUndo && !textEdit.readOnly
                text: i18n("Undo")
                icon: "edit-undo"
                onClicked: {
                    textEdit.undo();
                    scrollArea.scrollToCursor();
                }
            }

            PlasmaExtras.MenuItem {
                enabled: textEdit.canRedo && !textEdit.readOnly
                text: i18n("Redo")
                icon: "edit-redo"
                onClicked: {
                    textEdit.redo();
                    scrollArea.scrollToCursor();
                }
            }

            PlasmaExtras.MenuItem {
                text: i18n("Select all")
                onClicked: textEdit.selectAll();
            }
        }

        ColumnLayout {
            anchors.fill: parent

            QQC2.ScrollView {
                id: scrollArea

                readonly property bool canScrollUp: textEditFlickable.contentY !== 0
                readonly property bool canScrollDown: textEditFlickable.contentY + height < textEditFlickable.contentHeight + controlRow.height
                readonly property bool overflowing: textEdit.height > height

                QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AlwaysOff
                QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff

                function scrollToCursor() {
                    textEditFlickable.contentY = textEdit.cursorRectangle.y;
                    textEditFlickable.contentY -= textEditFlickable.verticalOvershoot;
                }
                function scrollUp() {
                    textEditFlickable.contentY -= textEdit.cursorHeight;
                    textEditFlickable.contentY -= textEditFlickable.verticalOvershoot;
                }
                function scrollDown(clicked) {
                    textEditFlickable.contentY += textEdit.cursorHeight
                    if(clicked) {
                        textEditFlickable.contentY -= textEditFlickable.verticalOvershoot;
                    }
                }

                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true

                Flickable {
                    id: textEditFlickable

                    interactive: false
                    pixelAligned: true
                    contentHeight: textEdit.contentHeight
                    boundsMovement: Flickable.FollowBoundsBehavior
                    boundsBehavior: Flickable.StopAtBounds

                    TextMetrics {
                        id: textMetrics
                        font.family: textEdit.font.family
                        text: "    "
                    }

                    TextEdit {
                        id: textEdit

                        readonly property int cursorHeight: textEdit.cursorRectangle.height
                        readonly property int cursorY: textEdit.cursorRectangle.y + textEdit.cursorRectangle.height
                        onCursorYChanged: {
                            if(!readOnly) {
                                if((cursorY <= textEditFlickable.contentY) && scrollArea.canScrollUp) scrollArea.scrollUp();
                                if((cursorY > textEditFlickable.contentY + scrollArea.height) && scrollArea.canScrollDown) scrollArea.scrollDown(false);
                            }
                        }

                        width: contentArea.width
                        height: implicitHeight < scrollArea.height ? scrollArea.height : implicitHeight


                        TapHandler {
                            id: textEditMA

                            //anchors.fill: parent
                            onTapped: (eventPoint, button)=> {
                                textEdit.forceActiveFocus();
                                // TextEdit has a strange issue in which if the last text is formatted, when switching
                                // from Markdown back to just plaintext, the whole text gets formatted. So to get
                                // around this, add an unformatted character at the end before switching to plaintext.
                                textEdit.insert(textEdit.length, '^');
                                textEdit.cursorPosition = textEdit.length;
                                textEdit.textFormat = Text.PlainText;
                                // There's another issue in where 2 empty new lines get added after switching, so
                                // remove everything that's past the ^ character
                                textEdit.remove(textEdit.text.lastIndexOf("^"), textEdit.text.length);
                                textEdit.cursorPosition = textEdit.positionAt(eventPoint.position.x, eventPoint.position.y);

                            }

                            enabled: textEdit.readOnly && Plasmoid.configuration.enableMarkdown
                        }

                        MouseArea {
                            acceptedButtons: Qt.RightButton
                            anchors.fill: parent
                            cursorShape: Qt.IBeamCursor
                            onClicked: mouse => {
                                contextMenu.open(mouse.x, mouse.y);
                            }
                        }

                        font.family: Plasmoid.configuration.fontFamily
                        font.styleName: Plasmoid.configuration.fontStyle
                        font.pointSize: Plasmoid.configuration.fontPointSize
                        leftPadding: (Plasmoid.configuration.sizeMode !== 0) ? 7 : 4
                        rightPadding: (Plasmoid.configuration.sizeMode !== 0) ? 7 : 4
                        wrapMode: Text.Wrap
                        textFormat: Plasmoid.configuration.enableMarkdown ? Text.MarkdownText : Text.PlainText
                        text: ""
                        color: Plasmoid.configuration.fontColorization == 1 ? root.textColor : root.autoTextColor
                        readOnly: Plasmoid.configuration.enableMarkdown && textFormat == Text.MarkdownText
                        baseUrl: StandardPaths.writableLocation(StandardPaths.HomeLocation);
                        tabStopDistance: textMetrics.width

                        Connections {
                            target: Plasmoid.configuration

                            function onEnableMarkdownChanged() {
                                textEdit.textFormat = Plasmoid.configuration.enableMarkdown ? Text.MarkdownText : Text.PlainText;
                            }
                        }

                        onCursorVisibleChanged: {
                            if(!cursorVisible && Plasmoid.configuration.enableMarkdown && contextMenu.status === PlasmaExtras.Menu.Closed) {
                                textEdit.textFormat = Text.MarkdownText;
                                notesManager.setText(text);
                            }

                        }
                    }
                }
            }

            RowLayout {
                id: controlRow

                spacing: 0

                opacity: hoverHandler.hovered

                CircleButton {
                    Layout.alignment: Qt.AlignVCenter

                    controlType: "delete"
                    enabled: notesManager.count > 1
                    onClicked: notesManager.deleteNote();
                }

                Item { Layout.fillWidth: true; Layout.preferredWidth: 2 }

                Image {
                    Layout.alignment: Qt.AlignVCenter

                    source: "../assets/controls/switcher-background.png"

                    RowLayout {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                            leftMargin: 2
                            right: parent.right
                            rightMargin: 2
                        }

                        height: 16

                        CircleButton {
                            controlType: "left"
                            enabled: notesManager.currentIndex !== 0
                            onClicked: {
                                notesManager.setText(textEdit.text);
                                notesManager.currentIndex -= 1;
                            }
                        }


                        Text {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            text: (notesManager.currentIndex+1) + "/" + notesManager.count
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }

                        CircleButton {
                            controlType: "right"
                            enabled: (notesManager.currentIndex+1) !== notesManager.count
                            onClicked: {
                                notesManager.setText(textEdit.text);
                                notesManager.currentIndex += 1;
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true; Layout.preferredWidth: 2 }

                CircleButton {
                    Layout.alignment: Qt.AlignVCenter

                    controlType: "add"
                    onClicked: notesManager.addNote()
                }
            }
        }

        Image {
            anchors {
                top: parent.top
                topMargin: (scrollArea.height / 2) - (height /2)
                right: parent.right
            }

            source: "../assets/controls/scroller-background.png"

            visible: scrollArea.overflowing && hoverHandler.hovered

            ColumnLayout {
                anchors {
                    fill: parent

                    topMargin: 2
                    bottomMargin: 2
                }

                spacing: 1

                CircleButton {
                    Layout.alignment: Qt.AlignHCenter

                    controlType: "up"
                    enabled: !textEditFlickable.atYBeginning
                    onClicked: scrollArea.scrollUp();
                }
                CircleButton {
                    Layout.alignment: Qt.AlignHCenter

                    controlType: "down"
                    enabled: !textEditFlickable.atYEnd
                    onClicked: scrollArea.scrollDown(true);
                }
            }
        }
    }
}
