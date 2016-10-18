import QtQuick 2.5
import QtQuick.Layouts 1.1

import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.volume 0.1

ColumnLayout {

    Repeater {
        delegate: sinkInputView
        model: PulseObjectFilterModel {
            filters: [{
                    role: "VirtualStream",
                    value: false
                }]
            sourceModel: SinkInputModel {
            }
        }
    }

    Component {
        id: sinkInputView

        ColumnLayout {
            Layout.fillWidth: true
            RowLayout {
                Layout.fillWidth: true

                VolumeController {
                    id: globalController
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    pulseObject: PulseObject
                    iconName: IconName
                }

                ExpanderArrow {
                    id: expanderIcon
                    Layout.alignment: Qt.AlignVCenter

                    implicitHeight: units.iconSizes.medium
                    implicitWidth: units.iconSizes.medium
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
                            deviceDetailsLoader.sourceComponent = sinkInputDetails
                            deviceDetailsLoader.expand()
                        }
                    }
                }
            ]

            Component {
                id: sinkInputDetails
                ColumnLayout {
                    PlasmaComponents.Label {
                        Layout.leftMargin: 6
                        text: Client.name;
                        elide: Text.ElideRight
                    }

                    DeviceComboBox {
                        Layout.fillWidth: true
                        model: sinkModel
                    }
                }
            }

        }
    }


}
