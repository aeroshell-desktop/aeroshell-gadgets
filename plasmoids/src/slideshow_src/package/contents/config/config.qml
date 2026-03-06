import QtQuick

import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
         name: i18n("General")
         icon: "image"
         source: "ConfigGeneral.qml"
    }
    ConfigCategory {
         name: i18n("Paths")
         icon: "folder"
         source: "ConfigPaths.qml"
    }
}
