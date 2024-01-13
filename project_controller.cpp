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
        container.append(QString::fromStdString(word));
    }
}

/// Считывает файл построчно, выделяет из строк слова.
/// Извещает вызывающую сторону о ходе прогресса.
void parseFile(QPromise<QList<OccurancyItem>>& promise,
               const std::string& filePath,
               const std::optional<std::size_t> wordsLimit = std::nullopt)
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

        // забираем отсортированный список результатов
        auto sortedList = container.toSortedList(Qt::DescendingOrder, wordsLimit);
        promise.addResult(std::move(sortedList));
    }
}

} // namespace


ProjectController::ProjectController(QObject* parent)
    : QObject(parent)
{
    initConnections();
}

void ProjectController::runParsingTask(const QString& filePath, const int wordsLimit)
{
    m_watcher.setFuture(
        QtConcurrent::run(parseFile,
                          filePath.toStdString(),
                          (NO_LIMIT == wordsLimit) ? std::nullopt
                                                   : std::make_optional(wordsLimit)));
}

void ProjectController::initConnections()
{
    connect(&m_watcher, &QFutureWatcherBase::progressRangeChanged,
            this, &ProjectController::progressRangeChanged);
    connect(&m_watcher, &QFutureWatcherBase::progressValueChanged,
            this, &ProjectController::progressValueChanged);
    connect(&m_watcher, &QFutureWatcherBase::resultReadyAt,
            this, &ProjectController::onResultReady);
}

void ProjectController::onResultReady(int resultIndex)
{
    emit itemsExtracted(m_watcher.resultAt(resultIndex));
}
