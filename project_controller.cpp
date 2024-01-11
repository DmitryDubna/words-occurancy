#include "project_controller.h"

#include <QDebug>
#include <QPromise>
#include <QtConcurrent/QtConcurrent>

namespace
{

void parseFile(QPromise<int>& promise, const std::string& filePath)
{
    qDebug() << QThread::currentThreadId() << "parseFile(" << QString::fromStdString(filePath) << ")" << Qt::endl;

    promise.setProgressRange(0, 100);
    for (int i = 0; i < 100; ++i)
    {
        QThread::sleep(1);
        promise.setProgressValue(i + 1);
    }
}

} // namespace


ProjectController::ProjectController(QObject* parent)
    : QObject(parent)
{
    initConnections();
}

void ProjectController::runParsingTask(const QString& filePath)
{
    qDebug() << QThread::currentThreadId() << "ProjectController::runParsingTask(" << filePath << ")" << Qt::endl;

    m_watcher.setFuture(QtConcurrent::run(parseFile, filePath.toStdString()));
}

void ProjectController::initConnections()
{
    connect(&m_watcher, &QFutureWatcherBase::progressValueChanged,
            this, [this](const int step)
    {
        emit progressChanged(step);
    });
}

