#pragma once

#include <QObject>
#include <qqml.h>


/// Элемент поиска, содержащий найденное слово и число его вхождений.
class OccurancyItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString word MEMBER m_word)
    Q_PROPERTY(std::size_t count MEMBER m_count)
    QML_ELEMENT
public:
    explicit OccurancyItem(QString word = {},
                           const std::size_t count = 0,
                           QObject* parent = nullptr)
        : QObject(parent)
        , m_word(std::move(word))
        , m_count(count)
    { }

public:
    QString word() const { return m_word; }
    std::size_t count() const { return m_count; }

private:
    QString m_word;
    std::size_t m_count;
};
