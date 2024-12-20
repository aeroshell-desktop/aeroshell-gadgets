/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.plasmoid
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

Item {
    property var generalModel
    property var observationModel

    Expanded {
        anchors.fill: parent
        visible: Plasmoid.configuration.expanded
    }
    Unexpanded {
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !Plasmoid.configuration.expanded
    }
}
