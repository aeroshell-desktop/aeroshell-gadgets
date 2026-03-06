import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kcmutils as KCM

import org.kde.plasma.plasmoid

KCM.SimpleKCM {
    id: root

    property int cfg_interval

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        RowLayout {
            Text {
                Layout.fillWidth: true
                text: i18n("Duration for each slide (in milliseconds):")
            }

            QQC2.TextField {
                id: interval

                text: Plasmoid.configuration.interval
                onTextChanged: root.cfg_interval = Number(interval.text);
                validator: IntValidator { bottom: 100 }
            }
        }
    }
}
