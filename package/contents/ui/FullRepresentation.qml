import QtQuick 2.5


Item {
    id: root

    Outputs {
        id: outputs
        anchors.bottom: inputs.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Inputs {
        id: inputs
        anchors.bottom: applications.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Applications {
        id: applications
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
