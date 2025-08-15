import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Effects

import Qt.labs.platform as Platform

import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: root

    property alias cfg_preset: preset.currentIndex
    property alias cfg_hue: hue.value
    property alias cfg_saturation: saturation.value
    property alias cfg_lightness: lightness.value

    property alias cfg_fontColorization: fontColorization.currentIndex
    property alias cfg_fontHue: fontHue.value
    property alias cfg_fontSaturation: fontSaturation.value
    property alias cfg_fontLightness: fontLightness.value
    property alias cfg_fontFamily: fontDialog.fontChosen.family
    property alias cfg_fontStyle: fontDialog.fontChosen.styleName
    property alias cfg_fontPointSize: fontDialog.fontChosen.pointSize

    property color noteColor: Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)
    property color textColor: Qt.hsla(fontHue.value/360, fontSaturation.value/100, fontLightness.value/100, 1.0)
    property color autoTextColor: {
        var yiq_y = ((noteColor.r * 0.299) + (noteColor.g * 0.587) + (noteColor.b * 0.114));
        return yiq_y >= 0.5 ? "black" : "white"
    }

    function rgbToHex(col) {
        const lut = "0123456789abcdef";
        const r = Math.floor(col.r * 255);
        const g = Math.floor(col.g * 255);
        const b = Math.floor(col.b * 255);
        return lut[Math.floor(r / 16)] + lut[r % 16] + lut[Math.floor(g / 16)] + lut[g % 16] + lut[Math.floor(b / 16)] + lut[b % 16];
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

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: noteBackground.width
            Layout.preferredHeight: noteBackground.height

            Image {
                id: noteBackground

                readonly property string color: {
                    switch(root.cfg_preset) {
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

                source: "../../assets/notes/" + color + "normal.png"

                layer.enabled: root.cfg_preset == 6
                layer.effect: MultiEffect {
                    colorization: 0.8
                    colorizationColor: root.noteColor
                }

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
                    color: fontColorization.currentIndex == 1 ? root.textColor : root.autoTextColor
                    readOnly: true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true

            uniformCellSizes: true

            CustomGroupBox {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true

                title: i18n("Color")

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    RowLayout {
                        Text {
                            text: i18n("Preset:")
                        }
                        QQC2.ComboBox {
                            id: preset

                            model: [
                                i18n("Yellow"),
                                i18n("Purple"),
                                i18n("Green"),
                                i18n("Pink"),
                                i18n("Blue"),
                                i18n("White"),
                                i18n("Custom")
                            ]
                            onCurrentIndexChanged: {
                                switch(currentIndex) {
                                    case 0:
                                        hue.value = 57;
                                        saturation.value = 100;
                                        lightness.value = 84;
                                        break;

                                    case 1:
                                        root.cfg_hue.value = 237;
                                        saturation.value = 96;
                                        lightness.value = 89;
                                        break;

                                    case 2:
                                        hue.value = 111;
                                        saturation.value = 100;
                                        lightness.value = 88;
                                        break;

                                    case 3:
                                        hue.value = 300;
                                        saturation.value = 94;
                                        lightness.value = 87;

                                    case 4:
                                        hue.value = 190;
                                        saturation.value = 93;
                                        lightness.value = 89;
                                        break;

                                    case 5:
                                        hue.value = 0;
                                        saturation.value = 0;
                                        lightness.value = 99;
                                        break;
                                }
                            }
                        }
                    }

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
                            stepSize: 1

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
                                    if(hue.enabled) {
                                        if(hue.pressed) return "-pressed"
                                        else if(hue.hovered) return "-hover"
                                    }
                                    return "-normal"
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

                                opacity: !hue.enabled ? 0.5 : 1.0
                            }

                            onMoved: preset.currentIndex = 6
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
                            stepSize: 1

                            background: Rectangle {
                                x: saturation.leftPadding
                                y: saturation.topPadding + saturation.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: saturation.availableWidth
                                height: saturation.availableHeight

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
                                    if(saturation.enabled) {
                                        if(saturation.pressed) return "-pressed"
                                        else if(saturation.hovered) return "-hover"
                                    }
                                    return "-normal"
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

                                opacity: !saturation.enabled ? 0.5 : 1.0
                            }

                            onMoved: preset.currentIndex = 6
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
                            stepSize: 1

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
                                    if(lightness.enabled) {
                                        if(lightness.pressed) return "-pressed"
                                        else if(lightness.hovered) return "-hover"
                                    }
                                    return "-normal"
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

                                opacity: !lightness.enabled ? 0.5 : 1.0
                            }

                            onMoved: preset.currentIndex = 6
                            onValueChanged: noteColor = Qt.hsla(hue.value/360, saturation.value/100, lightness.value/100, 1.0)
                        }
                    }
                    RowLayout {
                        Text {
                            Layout.fillWidth: true

                            text: i18n("HEX:")
                        }

                        Text {
                            text: "#"
                        }
                        QQC2.TextField {
                            id: hexEdit

                            Layout.minimumWidth: Math.round(systemFont.maximumCharacterWidth)*6
                            Layout.maximumWidth: Math.round(systemFont.maximumCharacterWidth)*6

                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Fa-f]+/ }
                            maximumLength: 6
                            text: rgbToHex(noteColor);
                            color: "black"

                            onTextEdited: {
                                hue.value = Qt.color("#" + text).hslHue*360;
                                saturation.value = Qt.color("#" + text).hslSaturation*100;
                                lightness.value = Qt.color("#" + text).hslLightness*100;
                            }

                            Connections {
                                target: root

                                function onNoteColorChanged() {
                                    hexEdit.text = rgbToHex(noteColor);
                                }
                            }
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
                                font.bold: true
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

                    RowLayout {
                        Text {
                            text: i18n("Colorization mode:")
                        }
                        QQC2.ComboBox {
                            id: fontColorization
                            model: [
                                i18n("Automatic"),
                                i18n("Custom")
                            ]
                        }
                    }

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Hue:")
                        }

                        QQC2.Slider {
                            id: fontHue

                            Layout.fillWidth: true

                            from: 0
                            to: 360
                            stepSize: 1

                            background: Rectangle {
                                x: fontHue.leftPadding
                                y: fontHue.topPadding + fontHue.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: fontHue.availableWidth
                                height: fontHue.availableHeight

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
                                    if(fontHue.enabled) {
                                        if(fontHue.pressed) return "-pressed"
                                        else if(fontHue.hovered) return "-hover"
                                    }
                                    return "-normal"
                                }

                                x: fontHue.leftPadding + fontHue.visualPosition * (fontHue.availableWidth - width)
                                y: fontHue.topPadding + fontHue.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"

                                opacity: !fontHue.enabled ? 0.5 : 1.0
                            }

                            enabled: fontColorization.currentIndex == 1
                            onValueChanged: textColor = Qt.hsla(fontHue.value/360, fontSaturation.value/100, fontLightness.value/100, 1.0)
                        }
                    }

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Saturation:")
                        }

                        QQC2.Slider {
                            id: fontSaturation

                            Layout.fillWidth: true

                            from: 0
                            to: 100
                            stepSize: 1

                            background: Rectangle {
                                x: fontSaturation.leftPadding
                                y: fontSaturation.topPadding + fontSaturation.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: fontSaturation.availableWidth
                                height: fontSaturation.availableHeight

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 6
                                    anchors.bottomMargin: 6

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal

                                        GradientStop { position: 0; color: Qt.hsla(fontHue.value/360, 0, fontLightness.value/100, 1.0) }
                                        GradientStop { position: 1; color: Qt.hsla(fontHue.value/360, 1.0, fontLightness.value/100, 1.0) }
                                    }
                                }
                            }

                            handle: BorderImage {
                                property string state: {
                                    if(fontSaturation.enabled) {
                                        if(fontSaturation.pressed) return "-pressed"
                                        else if(fontSaturation.hovered) return "-hover"
                                    }
                                    return "-normal"
                                }

                                x: fontSaturation.leftPadding + fontSaturation.visualPosition * (fontSaturation.availableWidth - width)
                                y: fontSaturation.topPadding + fontSaturation.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"

                                opacity: !fontSaturation.enabled ? 0.5 : 1.0
                            }

                            enabled: fontColorization.currentIndex == 1
                            onValueChanged: textColor = Qt.hsla(fontHue.value/360, fontSaturation.value/100, fontLightness.value/100, 1.0)
                        }
                    }

                    RowLayout {
                        uniformCellSizes: true

                        Text {
                            Layout.fillWidth: true

                            text: i18n("Lightness:")
                        }

                        QQC2.Slider {
                            id: fontLightness

                            Layout.fillWidth: true

                            from: 0
                            to: 100
                            stepSize: 1

                            background: Rectangle {
                                x: fontLightness.leftPadding
                                y: fontLightness.topPadding + fontLightness.availableHeight / 2 - height / 2
                                implicitWidth: 200
                                implicitHeight: 18
                                width: fontLightness.availableWidth
                                height: fontLightness.availableHeight

                                color: "transparent"

                                Rectangle {
                                    anchors.fill: parent
                                    anchors.topMargin: 6
                                    anchors.bottomMargin: 6

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal

                                        GradientStop { position: 0; color: Qt.hsla(fontHue.value/360, fontSaturation.value/100, 0, 1.0) }
                                        GradientStop { position: 1; color: Qt.hsla(fontHue.value/360, fontSaturation.value/100, 1.0, 1.0) }
                                    }
                                }
                            }

                            handle: BorderImage {
                                property string state: {
                                    if(fontLightness.enabled) {
                                        if(fontLightness.pressed) return "-pressed"
                                        else if(fontLightness.hovered) return "-hover"
                                    }
                                    return "-normal"
                                }

                                x: fontLightness.leftPadding + fontLightness.visualPosition * (fontLightness.availableWidth - width)
                                y: fontLightness.topPadding + fontLightness.availableHeight / 2 - height / 2

                                width: 10
                                height: 18

                                border {
                                    top: 2
                                    bottom: 3
                                    left: 2
                                    right: 3
                                }
                                source: "../../assets/config/thumb" + state + ".png"

                                opacity: !fontLightness.enabled ? 0.5 : 1.0
                            }

                            enabled: fontColorization.currentIndex == 1
                            onValueChanged: textColor = Qt.hsla(fontHue.value/360, fontSaturation.value/100, fontLightness.value/100, 1.0)
                        }
                    }

                    RowLayout {
                        Text {
                            Layout.fillWidth: true

                            text: i18n("HEX:")
                        }

                        Text {
                            text: "#"
                        }
                        QQC2.TextField {
                            id: fontHexEdit

                            Layout.minimumWidth: Math.round(systemFont.maximumCharacterWidth)*6
                            Layout.maximumWidth: Math.round(systemFont.maximumCharacterWidth)*6

                            validator: RegularExpressionValidator { regularExpression: /[0-9A-Fa-f]+/ }
                            maximumLength: 6
                            text: rgbToHex(textColor);
                            color: "black"
                            enabled: fontColorization.currentIndex == 1

                            onTextEdited: {
                                fontHue.value = Qt.color("#" + text).hslHue*360;
                                fontSaturation.value = Qt.color("#" + text).hslSaturation*100;
                                fontLightness.value = Qt.color("#" + text).hslLightness*100;
                            }

                            Connections {
                                target: root

                                function onTextColorChanged() {
                                    fontHexEdit.text = rgbToHex(textColor);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    FontMetrics { id: systemFont; font: hexEdit.font }

    Platform.FontDialog {
        id: fontDialog

        property font fontChosen: null

        title: i18n("Choose a Font")
        modality: Qt.WindowModal
        parentWindow: root.Window.window

        onAccepted: fontChosen = font
    }

    Component.onCompleted: {
        switch(preset.currentIndex) {
            case 0:
                hue.value = 57;
                saturation.value = 100;
                lightness.value = 84;

            case 1:
                hue.value = 237;
                saturation.value = 96;
                lightness.value = 89;

            case 2:
                hue.value = 111;
                saturation.value = 100;
                lightness.value = 88;

            case 3:
                hue.value = 300;
                saturation.value = 94;
                lightness.value = 87;

            case 4:
                hue.value = 190;
                saturation.value = 93;
                lightness.value = 89;

            case 5:
                hue.value = 0;
                saturation.value = 0;
                lightness.value = 99;
        }
    }
}
