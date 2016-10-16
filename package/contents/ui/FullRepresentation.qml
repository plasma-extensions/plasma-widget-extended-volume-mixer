import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.volume 0.1

Item {
    id: root

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
