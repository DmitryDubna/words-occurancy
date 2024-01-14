#pragma once

#include <QObject>
#include <QQmlEngine>


/// Перечисление "Тип действия пользователя."
class UserActionType final
{
    Q_GADGET
public:
    static void registerEnum(const QString& moduleName)
    {
        qmlRegisterUncreatableType<UserActionType>(
                moduleName.toStdString().c_str(),
                1,
                0,
                "UserActionType",
                QObject::tr("Невозможно создать экземпляр класса UserActionType!"));
    }

public:
    enum UserAction
    {
        Started,
        Suspended,
        Resumed,
        Canceled,
    };
    Q_ENUM(UserAction)

private:
    explicit UserActionType() = default;
};
