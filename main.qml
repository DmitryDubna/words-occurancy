import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import QtCharts
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import OccurancyItem 1.0

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int defaultAxisYMin: 0
    readonly property int defaultAxisYMax: 1
    readonly property int maxWordCount: 15
    readonly property int margin: 10

    visible: true
    width: pageWidth
    height: pageHeight

    Item {
        id: itemContent

        anchors.fill: parent

        ChartView {
            id: chartView

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: itemControls.top
            }
            theme: ChartView.ChartThemeBlueIcy
            antialiasing: true
            legend.visible: false

            BarSeries {
                id: series

                barWidth: 1
                axisX: BarCategoryAxis {
                    id: wordsAxis
                }
                axisY: ValueAxis {
                    id: countsAxis

                    min: defaultAxisYMin
                    max: defaultAxisYMax
                }

                BarSet {
                    id: yValues
                }
            }
        }

        Item {
            id: itemControls

            anchors {
                bottom: itemContent.bottom
                left: itemContent.left
                right: itemContent.right
                leftMargin: root.margin
                rightMargin: root.margin
                topMargin: root.margin
                bottomMargin: root.margin
            }

            height: rowProgress.height
                    + rowFilePath.height
                    + rowControlButtons.height
                    + 2 * columnControls.spacing

            ColumnLayout{
                id: columnControls

                anchors.fill: parent

                // прогрессбар + лейбл загрузки
                RowLayout {
                    id: rowProgress
                    layoutDirection: Qt.LeftToRight
                    spacing: 10

                    ProgressBar {
                        id: progressBar

                        Layout.fillWidth: true
                        from: 0
                        to: 100
                    }

                    Rectangle {
                        border.color: "gray"
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

                    function updateProgressValue(value)
                    {
                        progressBar.value = value
                        textProcessedBytes.text = `Обработано: ${value} / ${progressBar.to} байт`
                    }
                }

                // выбор пути к файлу
                RowLayout {
                    id: rowFilePath

                    Rectangle {
                        border.color: "gray"
                        radius: 4
                        height: buttonChooseFilePath.height
                        Layout.fillWidth: true

                        TextEdit {
                            id: editFilePath
                            anchors {
                                fill: parent
                                leftMargin: root.margin
                                rightMargin: root.margin
                            }
                            verticalAlignment: TextEdit.AlignVCenter
                        }
                    }

                    Button {
                        id: buttonChooseFilePath

                        text: "..."
                        onClicked: fileDialog.open()
                    }

                    FileDialog {
                        id: fileDialog

                        nameFilters: ["Text files (*.txt)"]
                        folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                        onAccepted: editFilePath.text = file
                    }
                }

                // кнопки управления процессом
                RowLayout {
                    id: rowControlButtons

                    // кнопка "Начать"
                    Button {
                        id: buttonStart

                        text: qsTr("Начать")
                        onClicked: rowControlButtons.parseFile(editFilePath.text, root.maxWordCount)

                    }

                    // кнопка "Приостановить"
                    Button {
                        id: buttonSuspend

                        text: qsTr("Приостановить")
//                        onClicked: ProjectController.runParsingTask("/home/dmitry/work/QtProjects/words-occurancy/pushkin.txt", root.maxWordCount);
                    }

                    // кнопка "Продолжить"
                    Button {
                        id: buttonResume

                        text: qsTr("Продолжить")
//                        onClicked: ProjectController.runParsingTask("/home/dmitry/work/QtProjects/words-occurancy/pushkin.txt", root.maxWordCount);
                    }

                    // кнопка "Завершить"
                    Button {
                        id: buttonStop

                        text: qsTr("Завершить")
                        //                        onClicked: ProjectController.runParsingTask("/home/dmitry/work/QtProjects/words-occurancy/pushkin.txt", root.maxWordCount);
                    }

                    function parseFile(filePath, maxWordCount)
                    {
                        ProjectController.runParsingTask(filePath, maxWordCount);
                    }
                }
            }
        }
    }

    // инициализирует обработчики сигналов
    function initConnections()
    {
        ProjectController.progressRangeChanged.connect(updateProgressRange)
        ProjectController.progressValueChanged.connect(updateProgressValue)
        ProjectController.itemsExtracted.connect(setItems)
    }

    // задает список объектов OccurancyItem
    function setItems(items)
    {
        if (!items || !items.length)
            return

        let words = []
        let counts = []

        items
            .sort((a, b) => b.count - a.count)
            .slice(0, root.maxWordCount)
            .sort((a, b) => a.word.localeCompare(b.word))
            .forEach(item => {
                         words.push(item.word)
                         counts.push(item.count)
                     });

        wordsAxis.categories = words
        yValues.values = counts

        countsAxis.max = Math.max(...counts)
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
        rowProgress.updateProgressValue(value)
    }

    Component.onCompleted: {
        root.initConnections()
        rowProgress.updateProgressValue(0)
    }
}
