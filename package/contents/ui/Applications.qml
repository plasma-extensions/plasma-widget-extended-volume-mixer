import QtQuick 2.5

import org.kde.plasma.private.volume 0.1

SinkInputView {
    id: sinkInputView

    height: 200

    model: PulseObjectFilterModel {
        filters: [{
                role: "VirtualStream",
                value: false
            }]
        sourceModel: SinkInputModel {
        }
    }
    emptyText: i18nc("@label", "No Applications Playing Audio")
}
