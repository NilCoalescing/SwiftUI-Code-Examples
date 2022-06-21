import Foundation
import TabularData

struct PenguinsDataPoint {
    static let url = URL(string: "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv")!
    
    enum Sex: String {
        case male = "MALE"
        case female = "FEMALE"
    }
    
    let species: String
    let island: String
    let billLength: Float
    let billDepth: Float
    let flipperLength: Float
    let bodyMass: Float
    let sex: Sex
    
    
    static func load() async throws -> [Self] {
        let (data, _) = try await URLSession.shared.data(from: Self.url)
        
        let dataFrame = try DataFrame.init(
            csvData: data,
            columns: [
                "species",
                "island",
                "bill_length_mm",
                "bill_depth_mm",
                "flipper_length_mm",
                "body_mass_g",
                "sex"
            ],
            types: [
                "species": CSVType.string,
                "island": CSVType.string,
                "bill_length_mm": CSVType.float,
                "bill_depth_mm": CSVType.float,
                "flipper_length_mm": CSVType.float,
                "body_mass_g": CSVType.float,
                "set": CSVType.string
            ],
            options: CSVReadingOptions(hasHeaderRow: true)
        )
        
        return dataFrame.rows.compactMap { row in
            guard
                let species = row["species", String.self],
                let island = row["island", String.self],
                let billLength = row["bill_length_mm", Float.self],
                let billDepth = row["bill_depth_mm", Float.self],
                let flipperLength = row["flipper_length_mm", Float.self],
                let bodyMass = row["body_mass_g", Float.self],
                let sex_string = row["sex", String.self], let sex = Sex(rawValue: sex_string) else {
                return nil
            }
            
            return Self.init(
                species: species,
                island: island,
                billLength: billLength,
                billDepth: billDepth,
                flipperLength: flipperLength,
                bodyMass: bodyMass,
                sex: sex
            )
        }
    }
}
