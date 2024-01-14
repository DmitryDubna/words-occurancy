import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    id: root

    property string borderColor: "gray"

    layoutDirection: Qt.LeftToRight
    spacing: 10

    ProgressBar {
        id: progressBar

        Layout.fillWidth: true
        from: 0
        to: 0
    }

    Rectangle {
        border.color: root.borderColor
        radius: 4
        height: progressBar.height
        width: textProcessedBytes.width

        Text {
            id: textProcessedBytes

            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            width: 400;
        }
    }

    // обновляет диапазон значений ProgressBar'а
    function updateProgressRange(min, max)
    {
        progressBar.from = min
        progressBar.to = max
    }

    // обновляет текущее значение ProgressBar'а
    function updateProgressValue(value)
    {
        progressBar.value = value
        textProcessedBytes.text = `Обработано: ${value} / ${progressBar.to} байт`
    }

    // сбрасывает значение ProgressBar'а в исходное
    function resetProgressValue()
    {
        const value = progressBar.from
        progressBar.value = value
        textProcessedBytes.text = `Обработано: ${value} / ${progressBar.to} байт`
    }
}
