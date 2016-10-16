import QtQuick 2.5
import QtQuick.Layouts 1.1

Loader {
    clip: true

    Layout.maximumHeight: Layout.minimumHeight

    NumberAnimation {
        id: showAnimation
        target: deviceDetailsLoader
        property: "Layout.minimumHeight"
        from: 0
        to: deviceDetailsLoader.implicitHeight
    }

    NumberAnimation {
        id: hideAnimation
        target: deviceDetailsLoader
        property: "Layout.minimumHeight"
        from: deviceDetailsLoader.implicitHeight
        to: 0
    }

    function expand () {
        showAnimation.running = true;
    }

    function collapse() {
        hideAnimation.running = true;
    }
}
