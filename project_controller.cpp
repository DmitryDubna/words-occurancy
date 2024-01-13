#include "project_controller.h"

#include <filesystem>
#include <fstream>
#include <regex.h>

#include <QPromise>
#include <QtConcurrent/QtConcurrent>

#include "utils.h"
#include "occurancy_item_container.h"

// FIXME: убрать после отладки
#include <QDebug>

namespace
{

constexpr const char* SPLIT_WORD_REGEX{ R"([,.:;?!<>|`~@#$%^&"\s\\\/\+\-\=\\*[\]\{\}\(\)]+)" };

/// Выделяет из строки слова с помощью регулярного выражения.
void parseLine(const std::string& line, OccurancyItemContainer& container)
{
    using namespace std;

    const vector<string> words = extractWords(line, regex(SPLIT_WORD_REGEX));
    for (const auto word : words)
    {
//        qDebug() << QString::fromStdString(word);
        container.append(QString::fromStdString(word));
    }
}

/// Считывает файл построчно, выделяет из строк слова.
/// Извещает вызывающую сторону о ходе прогресса.
void parseFile(QPromise<int>& promise, const std::string& filePath)
{
    std::ifstream file(filePath);
    std::string line;
    if (!file.is_open())
        return;

    // контейнер для хранения результатов
    OccurancyItemContainer container;

    // максимальное значение ProgressBar'а = размер файла
    const auto totalBytes = std::filesystem::file_size(filePath);
    promise.setProgressRange(0, totalBytes);

    // текущее значение ProgressBar'а = текущая позиция в файле
    std::uintmax_t bytesRead{ 0 };
    while (file)
    {
        // считаываем строку файла...
        std::getline(file, line);
        // ... и парсим
        parseLine(line, container);

        if ((bytesRead = file.tellg()) == -1)
            break;

        // обновляем позицию ProgressBar'а
        promise.setProgressValue(bytesRead);
    }

    // забираем отсортированный список результатов
    const auto sortedList = container.toSortedList(Qt::DescendingOrder, 1000);
    for (const auto& item : sortedList)
    {
        qDebug() << item.word() << ":" << item.count();
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
    m_watcher.setFuture(QtConcurrent::run(parseFile, filePath.toStdString()));
}

void ProjectController::initConnections()
{
    connect(&m_watcher, &QFutureWatcherBase::progressRangeChanged,
            this, &ProjectController::progressRangeChanged);
    connect(&m_watcher, &QFutureWatcherBase::progressValueChanged,
            this, &ProjectController::progressValueChanged);
}

