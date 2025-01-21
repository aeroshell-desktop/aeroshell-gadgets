import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_url: url.text

    ColumnLayout {
        Text {
            text: "RSS Feed URL"
        }

        QQC2.TextField {
            id: url

            Layout.fillWidth: true

            text: Plasmoid.configuration.url
        }
    }
}
