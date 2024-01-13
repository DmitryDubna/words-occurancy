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

QList<OccurancyItem> OccurancyItemContainer::toSortedList(Qt::SortOrder order, std::size_t limit)
{
    auto compare = [order](const auto& lhs, const auto& rhs)
    {
        return (Qt::AscendingOrder == order) ? lhs.count() < rhs.count()
                                             : lhs.count() > rhs.count();
    };

    QList<OccurancyItem> ret;
    std::transform(m_items.begin(),
                   m_items.end(),
                   std::back_inserter(ret),
                   [](const std::pair<QString, OccurancyItem>& item){ return item.second; });
    std::sort(ret.begin(), ret.end(), std::move(compare));

    return ret;
}
