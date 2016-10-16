import QtQuick 2.5

import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaCore.SvgItem {
    id: expanderIcon
    property bool expanded: false
    
    antialiasing: true
    svg: PlasmaCore.Svg {
        imagePath: "widgets/arrows"
    }
    elementId: "up-arrow"
    
    states: State {
        name: "rotated"
        PropertyChanges {
            target: expanderIcon
            rotation: 180
        }
        when: expanderIcon.expanded
    }
    
    transitions: Transition {
        RotationAnimation {
            direction: expanderIcon.expanded ? RotationAnimation.Clockwise : RotationAnimation.Counterclockwise
        }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: expanderIcon.expanded = !expanderIcon.expanded
    }
}