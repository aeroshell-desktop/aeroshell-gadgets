/*
 * SPDX-FileCopyrightText: 2018 Friedrich W. H. Kossebau <kossebau@kde.org>
 * SPDX-FileCopyrightText: 2022 Ismael Asensio <isma.af@gmail.com>
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.private.weather
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_expanded: expanded.checked

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: expanded
            text: "Expanded?"
        }
    }
}
