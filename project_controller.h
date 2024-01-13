#pragma once

#include <QObject>
#include <QFutureWatcher>
#include <QVariantList>

#include "occurancy_item.h"


/// Контроллер проекта - объект, осуществляющий взаимодействие backend (C++) c frontend'ом (QML).
class ProjectController : public QObject
{
    Q_OBJECT
public:
    explicit ProjectController(QObject* parent = nullptr);

public:
    /// Запускает в отдельном потоке задачу по выделению слов из текстового файла.
    Q_INVOKABLE void runParsingTask(const QString& filePath, int wordsLimit = NO_LIMIT);

private:
    static const int NO_LIMIT{ -1 };

signals:
    void progressRangeChanged(int min, int max);
    void progressValueChanged(int value);
    void parsingComplete(QList<OccurancyItem> items);

private:
    void initConnections();

private slots:
    void onParsingFinished();

private:
    QFutureWatcher<QList<OccurancyItem>> m_watcher;
};
