#pragma once

#include <QObject>
#include <qqml.h>

/// Элемент поиска, содержащий найденное слово и число его вхождений.
class OccurancyItem final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString word READ word)
    Q_PROPERTY(std::size_t count READ count)
    QML_ELEMENT
public:
    explicit OccurancyItem(QString word, const std::size_t count = 0)
        : m_word(std::move(word))
        , m_count(count)
    { }

public:
    QString word() const { return m_word; }
    std::size_t count() const { return m_count; }

private:
    QString m_word;
    std::size_t m_count;
};
