import Foundation
import TabularData


struct BabyNamesDataPoint {
    static let url = URL(string: "https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/5_OneCatSevNumOrdered.csv")!

    enum Sex: String {
        case male = "M"
        case female = "F"
    }
    
    let year: Date
    let sex: Sex
    let name: String
    let count: Int
    let proportion: Float
    
    
    static func load() async throws -> [Self] {
        let (data, _) = try await URLSession.shared.data(from: Self.url)
        
        var dataFrame = try DataFrame(
            csvData: data,
            columns: [
                "year",
                "sex",
                "name",
                "n",
                "prop"
            ],
            types: [
                "year": CSVType.integer,
                "sex": CSVType.string,
                "name": CSVType.string,
                "n": CSVType.integer,
                "prop": CSVType.float
            ],
            options: CSVReadingOptions(hasHeaderRow: true)
        )
        dataFrame.sort(on: "name")
        return dataFrame.rows.compactMap { row in
            guard
                let _year = row["year", Int.self],
                let year = Calendar.current.date(from: DateComponents(year: _year)),
                let name = row["name", String.self],
                let count = row["n", Int.self],
                let proportion = row["prop", Float.self],
                let sex_string = row["sex", String.self], let sex = Sex(rawValue: sex_string) else {
                return nil
            }

            return Self.init(year: year, sex: sex, name: name, count: count, proportion: proportion)
        }
    }
}


extension BabyNamesDataPoint: Identifiable {
    struct ObjectIdentifier: Hashable {
        let year: Date
        let name: String
    }
    var id: ObjectIdentifier {
        ObjectIdentifier(year: self.year, name: self.name)
    }
}
