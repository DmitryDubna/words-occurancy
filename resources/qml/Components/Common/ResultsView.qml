import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCharts


RowLayout {
    id: root

    readonly property int defaultAxisYMin: 0
    readonly property int defaultAxisYMax: 1
    readonly property int listWidth: 300
    readonly property int margin: 10

    property int maxWordCount: 15
    property string borderColor: "gray"

    function updateHistogram(items)
    {
        chartView.displayItems(items)
    }

    function updateList(items)
    {
        listItems.setItems(items)
    }

    function update(items)
    {
        updateHistogram(items)
        updateList(items)
    }

    Rectangle {
        id: rectChartBorder

        radius: 4
        border.color: root.borderColor

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: root.margin

        ChartView {
            id: chartView

            anchors.fill: parent
            theme: ChartView.ChartThemeQt
            antialiasing: true
            legend.visible: false

            BarSeries {
                id: series

                barWidth: 1
                axisX: BarCategoryAxis {
                    id: wordsAxis
                }
                axisY: ValueAxis {
                    id: countsAxis

                    min: root.defaultAxisYMin
                    max: root.defaultAxisYMax
                }

                BarSet {
                    id: yValues
                }
            }

            // визуализирует список объектов OccurancyItem
            function displayItems(items)
            {
                if (!items || !items.length)
                    return

                let words = []
                let counts = []

                items
                .sort((a, b) => b.count - a.count)
                .slice(0, root.maxWordCount)
                .sort((a, b) => a.word.localeCompare(b.word))
                .forEach(item => {
                             words.push(item.word)
                             counts.push(item.count)
                         });

                wordsAxis.categories = words
                yValues.values = counts

                countsAxis.max = Math.max(...counts)
            }
        }
    }

    OccurancyList {
        id: listItems

        maxItemCount: root.maxWordCount
        width: root.listWidth
        borderColor: root.borderColor
        Layout.fillHeight: true
        Layout.margins: root.margin
    }
}
