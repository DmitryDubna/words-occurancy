#pragma once

#include <unordered_map>

#include "occurancy_item.h"


/// Контейнер для хранения и модификации найденных слов и количества их вхождений.
class OccurancyItemContainer
{
public:
    explicit OccurancyItemContainer() = default;

public:
    void append(const QString& word);
    QList<OccurancyItem> toSortedList(Qt::SortOrder order = Qt::DescendingOrder,
                                      std::optional<std::size_t> limit = std::nullopt);

private:
    std::unordered_map<QString, OccurancyItem> m_items;
};
