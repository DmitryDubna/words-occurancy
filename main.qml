import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQml 2.15
import QtCharts 2.15
import OccurancyItem 1.0

Window {
    id: root

    readonly property int pageWidth: 1920
    readonly property int pageHeight: 1080
    readonly property int defaultAxisYMin: 0
    readonly property int defaultAxisYMax: 1
    readonly property int maxWordCount: 15

    visible: true
    width: pageWidth
    height: pageHeight

    Item {
        id: itemContent

        anchors.fill: parent

        ChartView {
            id: chartView

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: itemControls.top
            }
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

                    min: defaultAxisYMin
                    max: defaultAxisYMax
                }

                BarSet {
                    id: yValues
                }
            }
        }

        Item {
            id: itemControls

            height: 100
            anchors {
                bottom: itemContent.bottom
                left: itemContent.left
                right: itemContent.right
            }

            Button {
                id: buttonRun

                text: qsTr("Старт")
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                    margins: 10
                }

                onClicked: ProjectController.runParsingTask("/home/dmitry/work/CodeStyle/codestyle/README.md", root.maxWordCount);
            }

            ProgressBar {
                id: progressBar

                from: 0
                to: 100
                anchors {
                    left: buttonRun.right
                    right: parent.right
                    top: buttonRun.top
                    margins: 10
                }


            }
        }
    }

    function initConnections()
    {
        ProjectController.progressRangeChanged.connect(updateProgressRange)
        ProjectController.progressValueChanged.connect(updateProgressValue)
    }

    // объекты { "word", "count" }
    function setItems(items)
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

    function updateProgressRange(min, max)
    {
        progressBar.from = min
        progressBar.to = max
    }

    function updateProgressValue(value)
    {
        progressBar.value = value
    }

    // FIXME: убрать после отладки
    function test() {
        const items = [
                        { "word" : "авокадо", "count" : 20 },
                        { "word" : "брусника", "count" : 11 },
                        { "word" : "виноград", "count" : 21 },
                        { "word" : "дыня", "count" : 13 },
                        { "word" : "земляника", "count" : 20 },
                        { "word" : "калина", "count" : 15 },
                    ]
        root.setItems(items)
    }

    Component.onCompleted: root.initConnections()
}
