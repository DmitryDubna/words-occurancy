import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQml
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.platform
import Occurancy
import UserActionType

import Components.Common

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int maxWordCount: 15
    readonly property int margin: 10

    property int userAction: UserActionType.Canceled

    visible: true
    width: pageWidth
    height: pageHeight

    ColumnLayout {
        id: itemContent

        anchors.fill: parent

        // панель визуального представления результатов
        ResultsView {
            id: resultsView

            Layout.fillWidth: true
            Layout.fillHeight: true
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
                    folder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
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

    // обновляет визуальное отображение результатов
    function displayItems(items)
    {
        resultsView.update(items)
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
