#pragma once

#include <QObject>
#include <QFutureWatcher>
#include <QVariantList>

#include "occurancy_item.h"
#include "user_action_type.h"


/// Контроллер проекта - объект, осуществляющий взаимодействие backend (C++) c frontend'ом (QML).
class ProjectController : public QObject
{
    Q_OBJECT
public:
    explicit ProjectController(QObject* parent = nullptr);

public:
    /// Запускает в отдельном потоке задачу по выделению слов из текстового файла.
    Q_INVOKABLE void runParsingTask(const QUrl& filePath, int wordsLimit = NO_LIMIT);
    Q_INVOKABLE void suspendParsingTask();
    Q_INVOKABLE void resumeParsingTask();
    Q_INVOKABLE void cancelParsingTask();

private:
    static const int NO_LIMIT{ -1 };

signals:
    void progressRangeChanged(int min, int max);
    void progressValueChanged(int value);
    void itemsExtracted(QList<OccurancyItem> items);
    void userActionPerformed(UserActionType::UserAction type);

private:
    void initConnections();

private slots:
    void onResultReady(int resultIndex);

private:
    QFutureWatcher<QList<OccurancyItem>> m_watcher;
};
