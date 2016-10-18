import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.volume 0.1

PlasmaCore.IconItem {
    id: appletIcon
    property int iconSize: Math.min(parent.width, parent.height)
    property int maxVolumePercent: Plasmoid.configuration.maximumVolume
    property int maxVolumeValue: Math.round(maxVolumePercent * PulseAudio.NormalVolume / 100.0)
    property int volumeStep: Math.round(Plasmoid.configuration.volumeStep * PulseAudio.NormalVolume / 100.0)
    width: iconSize
    height: iconSize
    active: mouseArea.containsMouse
    colorGroup: PlasmaCore.ColorScope.colorGroup
    anchors.fill: parent

    SinkModel {
        id: sinkModel

        onDataChanged: syncProxyModel()

        function syncProxyModel() {
            // print("syncSinkProxyModel ")
            sinkModelProxy.clear()
            for (var i = 0; i < rowCount(); i++) {
                var idx = index(i, 0)
                var sink = data(idx, role("PulseObject"))
                // print (sink, sink.description);
                sinkModelProxy.append({
                                          text: sink.description,
                                          sink: sink
                                      })
                var isDefault = data(idx, role("Default"))
                if (isDefault && sinkModelProxy.defaultSinkIndex !== i)
                    sinkModelProxy.defaultSinkIndex = i
            }
        }

        function setDefaultSink(i) {
            // print ("setDefaultSink", i)
            if (i < rowCount()) {
                var idx = index(i, 0)
                setData(idx, 1, role("Default"))
            }
        }
    }
    ListModel {
        id: sinkModelProxy
        property var defaultSink: sinkModel.defaultSink
        property int defaultSinkIndex: -1

        onDefaultSinkIndexChanged: sinkModel.setDefaultSink(defaultSinkIndex)
    }

    SourceModel {
        id: sourceModel

        onDataChanged: syncProxyModel()

        function syncProxyModel() {
            // print("syncSourceProxyModel ")
            sourceModelProxy.clear()
            for (var i = 0; i < rowCount(); i++) {
                var idx = index(i, 0)
                var sink = data(idx, role("PulseObject"))
                // print (sink, sink.description);
                sourceModelProxy.append({
                                            text: sink.description,
                                            sink: sink
                                        })
                var isDefault = data(idx, role("Default"))
                if (isDefault && sourceModelProxy.defaultSourceIndex !== i)
                    sourceModelProxy.defaultSourceIndex = i
            }
        }

        function setDefaultSource(i) {
            // print ("setDefaultSink", i)
            if (i < rowCount()) {
                var idx = index(i, 0)
                setData(idx, 1, role("Default"))
            }
        }
    }

    ListModel {
        id: sourceModelProxy
        property var defaultSource: sourceModel.defaultSource
        property int defaultSourceIndex: -1

        onDefaultSourceIndexChanged: sourceModel.setDefaultSource(
                                         defaultSourceIndex)
    }

    function boundVolume(volume) {
        return Math.max(PulseAudio.MinimalVolume, Math.min(volume, maxVolumeValue));
    }

    function increaseVolume() {
        if (!sinkModel.preferredSink) {
            return
        }
        var volume = boundVolume(sinkModel.preferredSink.volume + volumeStep)
        sinkModel.preferredSink.muted = false
        sinkModel.preferredSink.volume = volume
        osd.show(volumePercent(volume, maxVolumeValue))
        playFeedback()
    }

    function decreaseVolume() {
        if (!sinkModel.preferredSink) {
            return
        }
        var volume = boundVolume(sinkModel.preferredSink.volume - volumeStep)
        sinkModel.preferredSink.muted = false
        sinkModel.preferredSink.volume = volume
        osd.show(volumePercent(volume, maxVolumeValue))
        playFeedback()
    }

    function muteVolume() {
        if (!sinkModel.preferredSink) {
            return
        }
        var toMute = !sinkModel.preferredSink.muted
        sinkModel.preferredSink.muted = toMute
        osd.show(toMute ? 0 : volumePercent(sinkModel.preferredSink.volume,
                                            maxVolumeValue))
        playFeedback()
    }

    MouseArea {
        id: mouseArea

        property int wheelDelta: 0
        property bool wasExpanded: false

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onPressed: {
            if (mouse.button == Qt.LeftButton) {
                wasExpanded = plasmoid.expanded
            } else if (mouse.button == Qt.MiddleButton) {
                muteVolume()
            }
        }
        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                if (!wasExpanded)
                    sidePanel.display()
                else
                    sidePanel.visible = false
            }
        }
        onWheel: {
            var delta = wheel.angleDelta.y || wheel.angleDelta.x
            wheelDelta += delta
            // Magic number 120 for common "one click"
            // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
            while (wheelDelta >= 120) {
                wheelDelta -= 120
                increaseVolume()
            }
            while (wheelDelta <= -120) {
                wheelDelta += 120
                decreaseVolume()
            }
        }
    }

    VolumeOSD {
        id: osd
    }

    VolumeFeedback {
        id: feedback
    }

    SidePanel {
        id: sidePanel
        FullRepresentation {
        }
    }
}
