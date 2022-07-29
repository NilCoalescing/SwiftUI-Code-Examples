import SwiftUI
import Charts

struct Walk {
    let title: String
    let duration: Measurement<UnitDuration>
}

struct ContentView: View {
    let walks = [
        Walk(
            title: "Taylors Mistake to Sumner Beach Coastal Walk",
            duration: Measurement(value: 3.1, unit: .hours)
        ),
        Walk(
            title: "Bottle Lake Forest",
            duration: Measurement(value: 2, unit: .hours)
        ),
        Walk(
            title: "Old Halswell Quarry Loop",
            duration: Measurement(value: 0.5, unit: .hours)
        ),
        Walk(
            title: "Avon River Trail",
            duration: Measurement(value: 2.5, unit: .hours)
        ),
        Walk(
            title: "Crater Rim Walkway",
            duration: Measurement(value: 5, unit: .hours)
        ),
        Walk(
            title: "Huntsbury Track",
            duration: Measurement(value: 1.5, unit: .hours)
        ),
        Walk(
            title: "Omahu Bush and Gibraltar Rock Circuit",
            duration: Measurement(value: 2.4, unit: .hours)
        ),
        Walk(
            title: "Travis Wetland Walkway",
            duration: Measurement(value: 0.7, unit: .hours)
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Comparison of walk durations:")
                .font(.headline)
            
            Chart(walks, id: \.title) { walk in
                BarMark(
                    x: .value("Duration", walk.duration),
                    y: .value("Walk", walk.title)
                )
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisValueLabel("""
                    \(value.as(Measurement.self)!
                        .converted(to: .hours),
                    format: .measurement(
                        width: .narrow,
                        numberFormatStyle: .number.precision(
                            .fractionLength(0))
                        )
                    )
                    """)
                }
            }
            .foregroundColor(.orange)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .frame(width: 500, height: 400)
        .navigationTitle("Chart with measurements")
    }
}

extension Measurement: Plottable where UnitType == UnitDuration {
    public var primitivePlottable: Double {
        self.converted(to: .minutes).value
    }

    public init?(primitivePlottable: Double) {
        self.init(value: primitivePlottable, unit: .minutes)
    }
}
