#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "project_controller.h"
#include "user_action_type.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QApplication app(argc, argv);

    // движок QML
    QQmlApplicationEngine engine;
    // регистрация пути к иерархии компонентов
    engine.addImportPath("qrc:/qml");
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject* obj, const QUrl& objUrl)
    {
        if (!obj && (url == objUrl))
            QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);

    // проброс сущностей из C++ в QML
    ProjectController projectController;
    engine.rootContext()->setContextProperty("ProjectController", &projectController);

    // регистрация enum
    UserActionType::registerEnum("UserActionType");

    // загрузка главного окна приложения
    engine.load(url);

    return app.exec();
}
