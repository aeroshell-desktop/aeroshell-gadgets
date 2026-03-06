import QtQuick
import Qt.labs.folderlistmodel
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import QtCore

Item {
    id: styleModel
    property list<FolderListModel> folderModels
    property list<var> styles;
    property list<string> builtinStyles: ["Default", "System", "Cronometer", "Diner", "Modern", "Square"]

    property var associations: {}

    signal modelUpdated()

    Component.onCompleted: {
        var standardPaths = StandardPaths.standardLocations(StandardPaths.GenericDataLocation);

        for(var path in standardPaths) {

            var evalPath = standardPaths[path] + "/win-gadgets/clockfaces";
            var fm = folderModel.createObject(styleModel, { folder: evalPath, rootFolder: evalPath });
            if(fm != null) {
                if(fm.folder == evalPath) {
                    folderModels.push(fm);
                }
            }
        }
    }

    function updateStyles() {
        associations = {};
        styles.length = 0;
        for(var i = 0; i < builtinStyles.length; i++) {
            styles.push({ value: "clocks/" + builtinStyles[i], text: i18n("%1 (built-in)", builtinStyles[i]), builtin: true});
        }
        for(var i = 0; i < folderModels.length; i++) {
            for(var it = 0; it < folderModels[i].count; it++) {
                var path = folderModels[i].get(it, "filePath");
                var basename = folderModels[i].get(it, "fileBaseName");

                if(typeof associations[basename] === "undefined") {
                    styles.push({ value: path, text: basename, builtin: false});
                    associations[basename] = path;
                }
            }
        }
        modelUpdated();
    }

    Component {
        id: folderModel
        FolderListModel {
            id: folderListModel
            showDirs: true
            showFiles: false
            onStatusChanged: {
                if (folderListModel.status == FolderListModel.Ready) styleModel.updateStyles();
            }
            onCountChanged: styleModel.updateStyles();
        }
    }

}
