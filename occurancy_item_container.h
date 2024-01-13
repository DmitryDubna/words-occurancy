#pragma once

#include <unordered_map>

#include "occurancy_item.h"


class OccurancyItemContainer
{
public:
    explicit OccurancyItemContainer() = default;

public:
    void append(const QString& word);
    QList<OccurancyItem> toSortedList(Qt::SortOrder order = Qt::DescendingOrder,
                                      std::size_t limit = DEFAULT_LIMIT);

private:
    static const std::size_t DEFAULT_LIMIT{ 100 };

private:
    std::unordered_map<QString, OccurancyItem> m_items;
};
