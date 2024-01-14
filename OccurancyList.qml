import QtQuick

Rectangle {
    id: root

    property int margin: 4
    property int listItemSpacing: 16
    property var itemDelegate: componentDelegate
    property var modelItems: []

    radius: 4
    border.color: "gray"
    anchors {
        leftMargin: root.margin
        rightMargin: root.margin
        topMargin: root.margin
        bottomMargin: root.margin
    }

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

        clip: true
        anchors.fill: root
//        anchors {
//            top: root.titleVisible ? lblTitle.bottom : root.top
//            left: root.left
//            right: root.right
//            bottom: root.bottom
//            leftMargin: root.horizontalContentPadding
//            rightMargin: root.horizontalContentPadding
//            topMargin: root.verticalContentPadding
//            bottomMargin: buttonVisible ? 99 : root.verticalContentPadding
//        }
        model: root.modelItems
        delegate: root.itemDelegate
        spacing: root.listItemSpacing
    }

    // делегат
    Component {
        id: componentDelegate

        Rectangle {
            id: rectDelegate

            property int margin: 20
            property int verticalContentPadding: 24
//            property int horizontalContentPadding: 32

            readonly property string wordRole: "word"
            readonly property string countRole: "count"

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: rectDelegate.margin
                rightMargin: rectDelegate.margin
                topMargin: rectDelegate.margin
                bottomMargin: rectDelegate.margin
            }
//            height: txtDateTime.height + txtMessage.height + 2 * verticalContentPadding
//            height: 20
            radius: 4

            Text {
                id: textWord

                width: parent.width / 2
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
//                    leftMargin: rectBubble.horizontalContentPadding
//                    topMargin: rectBubble.verticalContentPadding
                }
//                wrapMode: Text.WordWrap
//                font: root.itemFont
//                color: root.itemColor
//                opacity: 0.4
                text: modelData[wordRole]
            }
            Text {
                id: textCount

                anchors {
                    left: textWord.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
//                    leftMargin: rectBubble.horizontalContentPadding
//                    topMargin: rectBubble.verticalContentPadding
                }
//                anchors {
//                    left: parent.left
//                    right: parent.right
//                    top: txtDateTime.bottom
//                    leftMargin: rectBubble.horizontalContentPadding
//                    topMargin: 8
//                }
//                wrapMode: Text.WordWrap
//                font: root.itemFont
//                color: root.itemColor
                text: modelData[countRole]
            }
        }
    }
}
