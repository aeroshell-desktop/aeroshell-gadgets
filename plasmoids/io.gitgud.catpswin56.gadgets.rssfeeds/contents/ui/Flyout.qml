import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore

PlasmaCore.Dialog {
    type: PlasmaCore.Dialog.PopupMenu
    flags: Qt.WindowStaysOnTopHint
    hideOnWindowDeactivate: true
    backgroundHints: PlasmaCore.Types.NoBackground
    location: "RightEdge"

    property int itemIndex
    property string title: "undefined"
    property string link: "undefined"
    property string creator: "undefined"
    property string content: "undefined"
}
