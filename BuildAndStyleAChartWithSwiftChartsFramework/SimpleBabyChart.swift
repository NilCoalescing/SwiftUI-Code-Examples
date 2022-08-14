import Foundation
import SwiftUI
import Charts

struct SimpleBabyChart: View {
    let data: [BabyNamesDataPoint]
    
    @State var datesOfMaximumProportion: [
        (date: Date, name: String, yStart: Float, yEnd: Float)
    ] = []
    
    var body: some View {
        Chart {
            ForEach(data) { point in
                AreaMark(
                    x: .value("Date", point.year),
                    y: .value("Count", point.count),
                    stacking: .center
                ).foregroundStyle(by: .value("Name", point.name))
            }
            ForEach(
                datesOfMaximumProportion,
                id: \.name
            ) { point in
                RuleMark(
                    x: .value(
                        "Date of highest popularity for \(point.name)",
                        point.date
                    )
                )
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient (
                            colors: [
                                .indigo.opacity(0.05),
                                .purple.opacity(0.5)
                            ]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    ).blendMode(.darken)
                )
            }
            
            ForEach(datesOfMaximumProportion, id: \.name) { point in
                RuleMark(
                    x: .value("Date of highest popularity for \(point.name)", point.date),
                    yStart: .value("", point.yStart),
                    yEnd: .value("", point.yEnd)
                )
                .lineStyle(StrokeStyle(lineWidth: 0))
                    
                .annotation(
                    position: .overlay,
                    alignment: .center,
                    spacing: 4
                ){ context in
                    Text(point.name)
                        .font(.subheadline)
                        .padding(2)
                        .fixedSize()
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(.ultraThinMaterial)
                        )
                        .rotationEffect(
                            .degrees(-90),
                            anchor: .center
                        )
                        .fixedSize()
                        .foregroundColor(.secondary)
                }
            }
        }
        .chartForegroundStyleScale(
            range: Gradient (
                colors: [
                    .purple,
                    .blue.opacity(0.3)
                ]
            )
        )
        // Run this task again if we change the number of data points
        .task(id: data.count) {

            self.datesOfMaximumProportion = []

            var namesToMaxProportion: [String: (proportion: Float, date: Date)] = [:]
            for point in self.data {
                if namesToMaxProportion[point.name]?.proportion ?? 0 < point.proportion {
                    namesToMaxProportion[point.name] = (point.proportion, point.year)
                }
            }
            
            self.datesOfMaximumProportion = namesToMaxProportion.map { (key: String, value) in
                let name = key
                var countOnDate = 0
                var countBeforeOnDate = 0
                var countAfterOnDate = 0
                
                // Loop over all the data
                for point in self.data {
                    // We only need to consider data points for this year
                    if point.year != value.date { continue }
                    if point.name == name {
                        countOnDate = point.count
                        continue
                    }
                    
                    if countOnDate != 0 {
                        // We are dealing with sections that come after this name
                        countAfterOnDate += point.count
                    } else {
                        // We are dealing with sections that come before this name
                        countBeforeOnDate += point.count
                    }
                }
                
                let totalHeightOnDate = countOnDate + countAfterOnDate + countBeforeOnDate
                // The height is centred about the axis
                let lowestValue = -1 * Float(totalHeightOnDate) / 2.0
                let yStart = lowestValue + Float(countBeforeOnDate)
                let yEnd = yStart  + Float(countOnDate)
                
                return (value.date, key, yStart, yEnd)
            }
        }
    }
}
