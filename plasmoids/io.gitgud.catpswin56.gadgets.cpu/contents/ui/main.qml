import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    Layout.minimumWidth: 130
    Layout.minimumHeight: 103
    Layout.maximumWidth: 130
    Layout.maximumHeight: 103

    Plasmoid.backgroundHints: "NoBackground"

    property int cpu_usage: 0
    property real memory_usage: 0.0
    property real max_memory: 0.0

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(sourceName, exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            if (cmd) {
                connectSource(cmd)
            }
        }
        signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Connections {
        target: executable

        function onExited(cmd: string, exitCode: int, exitStatus: int, stdout: string, stderr: string) {
            var expression;
            var value;

            if(cmd == "top -bn1 | grep \"Cpu(s)\"") {
                expression = /\d{2}|\d{1}/m;
                value = expression.exec(stdout);
                root.cpu_usage = Math.round(Number(value[0]));

            } else {
                expression = /\d{1}.\d{1}|\d{2}/gm;
                value = stdout.match(expression);
                root.max_memory = Number(value[0]);
                root.memory_usage = Number(value[1]);

            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            executable.exec("top -bn1 | grep \"Cpu(s)\"");
            executable.exec("free -h");
        }
    }

    Image {
        id: bg

        anchors.centerIn: parent

        source: "resources/background.png"
    }

    Image {
        id: cpu_dial

        anchors.centerIn: bg
        anchors.horizontalCenterOffset: -23
        anchors.verticalCenterOffset: 6

        source: "resources/dials/cpu.png"

        // -127 = 0%
        // 120 = 100%
        rotation: Math.floor(((root.cpu_usage / 100) * 247) - 127)
        Behavior on rotation {
            NumberAnimation { duration: 1000 }
        }
    }

    Image {
        id: memory_dial

        anchors.centerIn: bg
        anchors.horizontalCenterOffset: 30
        anchors.verticalCenterOffset: -15

        source: "resources/dials/memory.png"

        // -114 = 0%
        // 114 = 100%
        rotation: Math.floor((((root.memory_usage - 0) / (root.max_memory - 0)) * 228) - 114)
        Behavior on rotation {
            NumberAnimation { duration: 1000 }
        }
    }

    Image {
        id: dots

        anchors.centerIn: bg

        source: "resources/dials/dots.png"
    }

    Text {
        anchors.top: cpu_dial.bottom
        anchors.topMargin: -16
        anchors.horizontalCenter: cpu_dial.horizontalCenter

        text: root.cpu_usage + "%"
        font.pointSize: 7
        font.bold: true
        color: "white"
    }

    Text {
        anchors.top: memory_dial.bottom
        anchors.topMargin: -18
        anchors.horizontalCenter: memory_dial.horizontalCenter

        text: Math.round(((root.memory_usage - 0) / (root.max_memory - 0)) * 100) + "%"
        font.pointSize: 7
        font.bold: true
        color: "white"
    }

    Image {
        id: reflection

        anchors.centerIn: bg

        source: "resources/reflection.png"
    }
}
