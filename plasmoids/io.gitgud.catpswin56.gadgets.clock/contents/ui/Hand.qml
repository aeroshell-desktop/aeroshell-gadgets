/*
    SPDX-FileCopyrightText: 2012 Viranch Mehta <viranch.mehta@gmail.com>
    SPDX-FileCopyrightText: 2012 Marco Martin <mart@kde.org>
    SPDX-FileCopyrightText: 2013 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick

import org.kde.ksvg as KSvg
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

Image {
    id: handRoot

    property alias rotation: rotation.angle

    anchors.centerIn: parent

    mirrorVertically: true
    transform: Rotation {
        id: rotation
        angle: 0
        origin {
            x: width / 2
            y: height / 2
        }
        Behavior on angle {
            RotationAnimation {
                id: anim
                duration: Kirigami.Units.longDuration
                direction: RotationAnimation.Clockwise
                easing.type: Easing.OutElastic
                easing.overshoot: 0.5
            }
        }
    }
}
