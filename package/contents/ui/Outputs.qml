import QtQuick 2.5
import QtQuick.Layouts 1.1

import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    height: content.implicitHeight
    ColumnLayout {
        id: content
        anchors.fill: parent

        spacing: 4

        RowLayout {
            id: controller
            Layout.fillWidth: true

            VolumeController {
                id: globalController
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                pulseObject: sinkModelProxy.defaultSink
            }

            ExpanderArrow {
                id: expanderIcon
                Layout.alignment: Qt.AlignVCenter

                implicitHeight: openSettingsButton.implicitHeight
                implicitWidth: openSettingsButton.implicitWidth
            }

            PlasmaComponents.ToolButton {
                id: openSettingsButton

                iconSource: "configure"
                tooltip: i18n("Configure Audio Volume...")

                onClicked: {
                    KCMShell.open(["pulseaudio"])
                }
            }
        }

        AnimatedLoader {
            id: deviceDetailsLoader
            Layout.fillWidth: true
            Layout.bottomMargin: 12
        }

        states: [
            State {
                name: "collapsed"
                when: !expanderIcon.expanded
                StateChangeScript {
                    script: {
                        if (deviceDetailsLoader.status == Loader.Ready) {
                            deviceDetailsLoader.collapse()
                            deviceDetailsLoader.sourceComponent = undefined
                        }
                    }
                }
            },
            State {
                name: "expanded"
                when: expanderIcon.expanded
                StateChangeScript {
                    script: {
                        deviceDetailsLoader.sourceComponent = details
                        deviceDetailsLoader.expand()
                    }
                }
            }
        ]
    }

    Component {
        id: details
        ColumnLayout {
            PlasmaComponents.Label {
                Layout.leftMargin: 6
                text: i18n("Outputs")
            }

            PlasmaComponents.ComboBox {
                id: outputsComboBox
                Layout.fillWidth: true
                textRole: "text"
                model: sinkModelProxy
                currentIndex: sinkModelProxy.defaultSinkIndex
                onCurrentIndexChanged: sinkModelProxy.defaultSinkIndex = currentIndex
            }

            PlasmaComponents.ComboBox {
                id: outputsPortsComboBox
                Layout.fillWidth: true
                model: sinkModel.defaultSink.ports
                onModelChanged: currentIndex = sinkModel.defaultSink.activePortIndex
                textRole: "description"
                currentIndex: sinkModel.defaultSink.activePortIndex
                onActivated: sinkModel.defaultSink.activePortIndex = index
            }
        }
    }
}
