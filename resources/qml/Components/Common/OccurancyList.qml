import QtQuick

Rectangle {
    id: root

    readonly property string wordRole: "word"
    readonly property string countRole: "count"

    property int itemPadding: 20
    property int listItemSpacing: 16
    property var itemDelegate: componentDelegate
    property var modelItems: []

    radius: 4
    border.color: "gray"

    function setItems(items)
    {
        modelItems = items
    }

    function appendItem(item)
    {
        modelItems.push(item)
    }

    function clearItems()
    {
        modelItems.length = 0
    }

    // список
    ListView {
        id: listItems

        anchors.fill: parent
        clip: true
        model: root.modelItems
        delegate: root.itemDelegate
        spacing: root.listItemSpacing
    }

    // делегат
    Component {
        id: componentDelegate

        Text {
            text: `${modelData[wordRole]} : ${modelData[countRole]}`
        }

//        Rectangle {
//            id: rectDelegate

//            anchors {
//                left: parent.left
//                right: parent.right
//                leftMargin: rectDelegate.itemPadding
//                rightMargin: rectDelegate.itemPadding
//                topMargin: rectDelegate.itemPadding
//                bottomMargin: rectDelegate.itemPadding
//            }
//            radius: 4

//            Text {
//                id: textWord

//                width: parent.width / 2
//                anchors {
//                    left: parent.left
//                    top: parent.top
//                    bottom: parent.bottom
//                }
//                text: modelData[wordRole]
//            }
//            Text {
//                id: textCount

//                anchors {
//                    left: textWord.right
//                    right: parent.right
//                    top: parent.top
//                    bottom: parent.bottom
//                }
//                text: modelData[countRole]
//            }
//        }
    }
}
