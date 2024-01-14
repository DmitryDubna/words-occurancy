import QtQuick

Rectangle {
    id: root

    readonly property string wordRole: "word"
    readonly property string countRole: "count"

    property int maxItemCount: 30
    property int itemPadding: 20
    property int itemHeight: 30
    property int itemFontSize: 14
    property int headerHeight: 40
    property int headerMargin: 10
    property int headerFontSize: 16
    property string borderColor: "gray"
    property var modelItems: []

    radius: 4
    border.color: root.borderColor

    function setItems(items)
    {
        modelItems = items
    }

    // заголовок
    Text {
        id: textHeader

        height: root.headerHeight
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: root.headerMargin
        }

        horizontalAlignment: Qt.AlignCenter
        font.pixelSize: root.headerFontSize
        font.bold: true
        text: qsTr("Топ-") + root.maxItemCount
    }

    // список
    ListView {
        id: listItems

        anchors {
            top: textHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        clip: true
        model: root.modelItems
        delegate: delegateItem
    }

    // делегат элемента списка
    Component {
        id: delegateItem

        Rectangle {
            height: root.itemHeight
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: root.itemPadding
                rightMargin: root.itemPadding
            }

            Text {
                id: textWord

                width: parent.width / 2
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                font.pixelSize: root.itemFontSize
                text: modelData[wordRole]
            }

            Text {
                id: textCount

                anchors {
                    left: textWord.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                font.pixelSize: root.itemFontSize
                text: modelData[countRole]
            }
        }
    }
}
