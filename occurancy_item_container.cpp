#include "occurancy_item_container.h"

void OccurancyItemContainer::append(const QString& word)
{
    auto it = m_items.find(word);
    if (m_items.cend() == it)
    {
        m_items.emplace(word, OccurancyItem(word));
        return;
    }

    it->second.increment();
}

QList<OccurancyItem> OccurancyItemContainer::toSortedList(Qt::SortOrder order,
                                                          std::optional<std::size_t> limit)
{
    auto convert = [](const std::pair<QString, OccurancyItem>& item)
    {
        return item.second;
    };

    auto compare = [order](const auto& lhs, const auto& rhs)
    {
        return (Qt::AscendingOrder == order) ? lhs.count() < rhs.count()
                                             : lhs.count() > rhs.count();
    };

    QList<OccurancyItem> ret;
    std::transform(m_items.begin(), m_items.end(), std::back_inserter(ret), convert);
    std::sort(ret.begin(), ret.end(), std::move(compare));

    if (limit.has_value())
    {
        ret.erase(std::next(ret.begin(), limit.value()), ret.end());
    }

    return ret;
}
