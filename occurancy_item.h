#pragma once

#include <QObject>
#include <QString>
#include <qqml.h>


/// Элемент поиска, содержащий найденное слово и число его вхождений.
class OccurancyItem
{
    Q_GADGET
    Q_PROPERTY(QString word MEMBER m_word)
    Q_PROPERTY(std::size_t count MEMBER m_count)
//    QML_ELEMENT
public:
    explicit OccurancyItem(QString word = {},
                           const std::size_t count = DEFAULT_COUNT)
        : m_word(std::move(word))
        , m_count(count)
    { }

public:
    QString word() const { return m_word; }
    std::size_t count() const { return m_count; }

    void increment() { ++m_count; }

private:
    static const std::size_t DEFAULT_COUNT{ 1 };

private:
    QString m_word;
    std::size_t m_count;
};

Q_DECLARE_METATYPE(OccurancyItem)
