import SwiftUI
import Charts


struct PenguinChart2D: View {
    let dataset: [PenguinsDataPoint]
    
    struct TwoDimensionalBinIndex: Hashable {
        let xBinIndex: Int
        let yBinIndex: Int
    }
    
    typealias BinnedValue = (
        index: TwoDimensionalBinIndex,
        xDataRange: ChartBinRange<Float>,
        yDataRange: ChartBinRange<Float>,
        frequency: Int
    )
    
    
    var bins: [BinnedValue] {
        let flipperLengthBins = NumberBins(
            data: dataset.map(\.flipperLength),
            desiredCount: 25
        )

        let billLengthBins = NumberBins(
            data: dataset.map(\.billLength),
            desiredCount: 25
        )
        
        let groupedData = Dictionary(
            grouping: dataset
        ) { element in
            TwoDimensionalBinIndex(
                xBinIndex: flipperLengthBins
                    .index(for: element.flipperLength),
                yBinIndex: billLengthBins
                    .index(for: element.billLength)
            )
        }

        let values = groupedData
            .map { key, values in
                return (
                    index: key,
                    xDataRange: flipperLengthBins[
                        key.xBinIndex
                    ],
                    yDataRange: billLengthBins[
                        key.yBinIndex
                    ],
                    frequency: values.count
                )
            }
        
        return values
    }
    
    var body: some View {
        Chart(
            self.bins, id: \.index
        ) { element in
            RectangleMark(
                x: .value(
                    "Flipper Length",
                    element.xDataRange
                ),
                y: .value(
                    "Bill Length",
                    element.yDataRange
                ),
                width: .ratio(1),
                height: .ratio(1)
            )
            .foregroundStyle(
                by: .value(
                    "Frequency",
                    element.frequency
                )
            )
        }
        .chartXScale(
            domain: .automatic(
                includesZero: false
            )
        )
        .chartYScale(
            domain: .automatic(
                includesZero: false
            )
        )
        .chartForegroundStyleScale(
            range: Gradient(
                colors: [
                    Color.red.opacity(0.1),
                    Color.yellow
                ]
            )
        )
    }
}




struct PenguinChart: View {
    let dataset: [PenguinsDataPoint]
    
    var binnedData: [
        (
            index: Int,
            range: ChartBinRange<Float>,
            frequency: Int
        )
    ] {
        let bins = NumberBins(
            data: dataset.map(\.billLength),
            desiredCount: 30
        )
        
        let groups = Dictionary(
            grouping: dataset.map(\.billLength),
            by: bins.index
        )
        
        let preparedData = groups.map { key, values in
             return (
                index: key,
                range: bins[key],
                frequency: values.count
            )
        }
        
        return preparedData
    }
    
    var body: some View {
        Chart(self.binnedData, id: \.index) { element in
            BarMark(
                x: .value("Bill Length", element.range),
                y: .value("Frequency", element.frequency)
            )
        }
        .chartXScale(domain: .automatic(includesZero: false))
    }
}
