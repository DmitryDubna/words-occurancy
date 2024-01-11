#pragma once

#include <QObject>
#include <QFutureWatcher>

class ProjectController : public QObject
{
    Q_OBJECT
public:
    explicit ProjectController(QObject* parent = nullptr);

public:
    Q_INVOKABLE void runParsingTask(const QString& filePath);

signals:
    void progressChanged(int value);

private:
    void initConnections();

private:
    QFutureWatcher<int> m_watcher;

};
