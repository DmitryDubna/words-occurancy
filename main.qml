import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int wordCount: 5

    visible: true
    width: pageWidth
    height: pageHeight

    ChartView {
        id: chartView
        anchors.fill: parent
        theme: ChartView.ChartThemeBrownSand
        legend.alignment: Qt.AlignBottom
        antialiasing: true

        BarSeries {
            id: series
            barWidth: 1
            axisX: BarCategoryAxis {
                id: wordsAxis
            }
            axisY: ValueAxis {
                id: countsAxis
                min: 0
                max: 1
            }

            BarSet {
                id: yValues
            }
        }
    }

    // объекты { "word", "count" }
    function update(items)
    {
        if (!items || !items.length)
            return

        let words = []
        let counts = []
        let maxCount = 0

        items
            .sort((a, b) => b.count - a.count)
            .slice(0, root.wordCount)
            .sort((a, b) => a.word.localeCompare(b.word))
            .forEach(item => {
                         words.push(item.word)
                         counts.push(item.count)

                         if (maxCount < item.count)
                            maxCount = item.count
                     });

        wordsAxis.categories = words
        yValues.values = counts

        countsAxis.max = maxCount
    }

    // FIXME: убрать тестовое заполнение
    Component.onCompleted: {
        const items = [
            { "word" : "авокадо", "count" : 20 },
            { "word" : "брусника", "count" : 11 },
            { "word" : "виноград", "count" : 21 },
            { "word" : "дыня", "count" : 13 },
            { "word" : "земляника", "count" : 20 },
            { "word" : "калина", "count" : 15 },
        ]
        root.update(items)
    }
}