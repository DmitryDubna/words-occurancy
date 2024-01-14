import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.platform as Labs

RowLayout {
    id: root

    property bool buttonEnabled: true
    property string borderColor: "gray"
    property string filePath: editFilePath.text
    property var filter: ["Text files (*.txt)"]
    property int horizontalTextPadding: 20

    Rectangle {
        border.color: root.borderColor
        radius: 4
        height: buttonChooseFilePath.height
        Layout.fillWidth: true

        TextEdit {
            id: editFilePath

            color: root.borderColor
            enabled: false
            anchors {
                fill: parent
                leftMargin: root.margin
                rightMargin: root.margin
            }
            verticalAlignment: TextEdit.AlignVCenter
            leftPadding: root.horizontalTextPadding
            rightPadding: root.horizontalTextPadding
        }
    }

    Button {
        id: buttonChooseFilePath

        enabled: root.buttonEnabled
        text: "..."
        onClicked: fileDialog.open()
    }

    FileDialog {
        id: fileDialog

        nameFilters: root.filter
        currentFolder: Labs.StandardPaths.standardLocations(Labs.StandardPaths.DocumentsLocation)[0]

        onAccepted: editFilePath.text = currentFile
    }
}
