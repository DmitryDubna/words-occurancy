import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import UserActionType

RowLayout {
    id: root

    property int userAction: UserActionType.Canceled
    property bool fileSelected: false

    signal buttonStartClicked()
    signal buttonSuspendClicked()
    signal buttonResumeClicked()
    signal buttonCancelClicked()

    // кнопка "Начать"
    Button {
        id: buttonStart

        text: qsTr("Начать")
        enabled: (root.userAction === UserActionType.Canceled) && (root.fileSelected)

        onClicked: root.buttonStartClicked()
    }

    // кнопка "Приостановить"
    Button {
        id: buttonSuspend

        text: qsTr("Приостановить")
        enabled: (root.userAction === UserActionType.Started) || (root.userAction === UserActionType.Resumed)

        onClicked: root.buttonSuspendClicked()
    }

    // кнопка "Продолжить"
    Button {
        id: buttonResume

        text: qsTr("Продолжить")
        enabled: (root.userAction === UserActionType.Suspended)

        onClicked: root.buttonResumeClicked()
    }

    // кнопка "Завершить"
    Button {
        id: buttonStop

        text: qsTr("Завершить")
        enabled: (root.userAction !== UserActionType.Canceled)

        onClicked: root.buttonCancelClicked()
    }
}
