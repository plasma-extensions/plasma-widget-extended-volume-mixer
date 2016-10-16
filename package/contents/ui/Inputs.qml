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
                pulseObject: sourceModelProxy.defaultSource
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
                text: i18n("Inputs")
            }

            PlasmaComponents.ComboBox {
                id: inputsComboBox
                Layout.fillWidth: true
                textRole: "text"
                model: sourceModelProxy
                currentIndex: sourceModelProxy.defaultSourceIndex
                onCurrentIndexChanged: sourceModelProxy.defaultSourceIndex = currentIndex
            }

            PlasmaComponents.ComboBox {
                id: inputsPortsComboBox
                Layout.fillWidth: true
                model: sourceModel.defaultSource.ports
                onModelChanged: currentIndex = sourceModel.defaultSource.activePortIndex
                textRole: "description"
                currentIndex: sourceModel.defaultSource.activePortIndex
                onActivated: sourceModel.defaultSource.activePortIndex = index
            }
        }
    }
}
