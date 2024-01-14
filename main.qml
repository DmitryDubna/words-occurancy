import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import QtCharts
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import Occurancy
import UserActionType

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int defaultAxisYMin: 0
    readonly property int defaultAxisYMax: 1
    readonly property int maxWordCount: 15
    readonly property int margin: 10
    readonly property int listWidth: 300

    property int userAction: UserActionType.Canceled

    visible: true
    width: pageWidth
    height: pageHeight

    ColumnLayout {
        id: itemContent

        anchors.fill: parent

        // панель визуального представления результатов
        RowLayout {
            id: rowResultView

            ChartView {
                id: chartView

                Layout.fillWidth: true
                Layout.fillHeight: true
                theme: ChartView.ChartThemeQt
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

                // визуализирует список объектов OccurancyItem
                function displayItems(items)
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
            }

            OccurancyList {
                id: listItems

                width: root.listWidth
                Layout.fillHeight: true
                Layout.margins: root.margin
            }
        }

        // панель органов управления
        ColumnLayout {
            id: columnControls

            Layout.margins: root.margin

            // прогрессбар + лейбл загрузки
            RowLayout {
                id: rowProgress
                layoutDirection: Qt.LeftToRight
                spacing: 10

                ProgressBar {
                    id: progressBar

                    Layout.fillWidth: true
                    from: 0
                    to: 0
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

                        color: "gray"
                        enabled: false
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

                    enabled: (root.userAction === UserActionType.Canceled) || (root.userAction === UserActionType.Suspended)
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
                    enabled: (root.userAction === UserActionType.Canceled) && (editFilePath.text)

                    onClicked: rowControlButtons.runParsingTask(editFilePath.text, root.maxWordCount)
                }

                // кнопка "Приостановить"
                Button {
                    id: buttonSuspend

                    text: qsTr("Приостановить")
                    enabled: (root.userAction === UserActionType.Started) || (root.userAction === UserActionType.Resumed)

                    onClicked: rowControlButtons.suspendParsingTask()
                }

                // кнопка "Продолжить"
                Button {
                    id: buttonResume

                    text: qsTr("Продолжить")
                    enabled: (root.userAction === UserActionType.Suspended)

                    onClicked: rowControlButtons.resumeParsingTask()
                }

                // кнопка "Завершить"
                Button {
                    id: buttonStop

                    text: qsTr("Завершить")
                    enabled: (root.userAction !== UserActionType.Canceled)

                    onClicked: rowControlButtons.cancelParsingTask()
                }

                function runParsingTask(filePath, maxWordCount)
                {
                    ProjectController.runParsingTask(filePath, maxWordCount);
                }

                function suspendParsingTask()
                {
                    ProjectController.suspendParsingTask();
                }

                function resumeParsingTask()
                {
                    ProjectController.resumeParsingTask();
                }

                function cancelParsingTask()
                {
                    ProjectController.cancelParsingTask();
                }
            }
        }
    }

    // инициализирует обработчики сигналов
    function initConnections()
    {
        ProjectController.progressRangeChanged.connect(updateProgressRange)
        ProjectController.progressValueChanged.connect(updateProgressValue)
        ProjectController.itemsExtracted.connect(displayItems)
        ProjectController.userActionPerformed.connect(setUserAction)
    }

    // задает список объектов OccurancyItem
    function displayItems(items)
    {
        chartView.displayItems(items)
        listItems.setItems(items)
    }

    // обновляет диапазон значений ProgressBar'а
    function updateProgressRange(min, max)
    {
        rowProgress.updateProgressRange(min, max)
    }

    // обновляет текущее значение ProgressBar'а
    function updateProgressValue(value)
    {
        rowProgress.updateProgressValue(value)
    }

    // устанавливает текущее действие пользователя
    function setUserAction(action)
    {
        root.userAction = action
    }

    Component.onCompleted: {
        root.initConnections()
        rowProgress.updateProgressValue(0)
    }
}
