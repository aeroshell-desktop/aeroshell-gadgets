import QtQuick

import org.kde.kirigami as Kirigami

import org.kde.plasma.plasmoid

QtObject {
    id: stylesModel

    property var currentStyle: styles[Plasmoid.configuration.clockStyle]
    property var styles:
    [
        {
            styleName: "Default",
            hasShine: true
        },
        {
            styleName: "System",
            hasShine: true
        },
        {
            styleName: "Cronometer",
            hasShine: true
        },
        {
            styleName: "Diner",
            hasShine: false
        },
        {
            styleName: "Modern",
            hasShine: false
        },
        {
            styleName: "Square",
            hasShine: true
        }
    ]
}
