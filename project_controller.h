#pragma once

#include <QObject>
#include <QFutureWatcher>


/// Контроллер проекта - объект, осуществляющий взаимодействие backend (C++) c frontend'ом (QML).
class ProjectController : public QObject
{
    Q_OBJECT
public:
    explicit ProjectController(QObject* parent = nullptr);

public:
    /// Запускает в отдельном потоке задачу по выделению слов из текстового файла.
    Q_INVOKABLE void runParsingTask(const QString& filePath);

signals:
    void progressRangeChanged(int min, int max);
    void progressValueChanged(int value);

private:
    void initConnections();

private:
    QFutureWatcher<int> m_watcher;
};
