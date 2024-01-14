import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import Occurancy
import UserActionType

import Components.Common

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int maxWordCount: 15
    readonly property int margin: 10
    readonly property var selectedFile: panelFileChoose.filePath

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
            ProgressPanel {
                id: panelProgress
            }

            // выбор пути к файлу
            FileChoosePanel {
                id: panelFileChoose

                buttonEnabled: (root.userAction === UserActionType.Canceled) || (root.userAction === UserActionType.Suspended)
            }

            // кнопки управления процессом
            ControlButtonPanel {
                id: panelControlButtons

                userAction: root.userAction
                fileSelected: root.selectedFile
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
        panelControlButtons.buttonStartClicked.connect(runParsingTask)
        panelControlButtons.buttonSuspendClicked.connect(suspendParsingTask)
        panelControlButtons.buttonResumeClicked.connect(resumeParsingTask)
        panelControlButtons.buttonCancelClicked.connect(cancelParsingTask)
    }

    // обновляет визуальное отображение результатов
    function displayItems(items)
    {
        resultsView.update(items)
    }

    // обновляет диапазон значений ProgressBar'а
    function updateProgressRange(min, max)
    {
        panelProgress.updateProgressRange(min, max)
    }

    // обновляет текущее значение ProgressBar'а
    function updateProgressValue(value)
    {
        panelProgress.updateProgressValue(value)
    }

    // обновляет текущее значение ProgressBar'а
    function resetProgressValue(value)
    {
        panelProgress.resetProgressValue()
    }

    // устанавливает текущее действие пользователя
    function setUserAction(action)
    {
        root.userAction = action
    }

    function runParsingTask()
    {
        ProjectController.runParsingTask(root.selectedFile, root.maxWordCount);
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

    Component.onCompleted: {
        root.initConnections()
        root.resetProgressValue()
    }
}
