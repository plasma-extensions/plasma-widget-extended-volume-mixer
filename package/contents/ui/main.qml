import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0


Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    property string displayName: i18n("Extended Volume Mixer")

    Plasmoid.toolTipMainText: displayName
    Plasmoid.toolTipSubText: ""

    // Plasmoid.fullRepresentation:  FullRepresentation { anchors.fill: parent }
    Plasmoid.compactRepresentation: CompactRepresentation {}

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
}
