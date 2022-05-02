import Foundation

struct RandomSentenceGenerator {
    static private var letters: [String: Float] = [
        "E": 12.02,
        "T": 9.10,
        "A": 8.12,
        "O": 7.68,
        "I": 7.31,
        "N": 6.95,
        "S": 6.28,
        "R": 6.02,
        "H": 5.92,
        "D": 4.32,
        "L": 3.98,
        "U": 2.88,
        "C": 2.71,
        "M": 2.61,
        "F": 2.30,
        "Y": 2.11,
        "W": 2.09,
        "G": 2.03,
        "P": 1.82,
        "B": 1.49,
        "V": 1.11,
        "K": 0.69,
        "X": 0.17,
        "Q": 0.11,
        "J": 0.10,
        "Z": 0.07,
    ]
    
    static private var letterThresholds: [(Float, String)] = {
        let letterPairs = letters.sorted { (a, b) -> Bool in
            a.value < b.value
        }
        
        var sum: Float = 0.0
        
        var thresholdletters: [(Float, String)] = []
        
        for letterPair in letterPairs {
            sum += letterPair.value
            thresholdletters.append(
                (
                    sum, letterPair.key
                )
            )
        }
        return thresholdletters
    }()
    
    static func generateSentence(of lenght: Int = 18) -> String {
        return (0..<lenght).map {_ in
            generateWord(of: Int.random(in: 2..<7))
        }.joined(separator: " ").lowercased()
    }

    static func generateWord(of lenght: Int) -> String {
        (0..<lenght).map { _ in
            let value = Float.random(in: 0..<100)
            for (threshold, letter) in letterThresholds {
                if threshold > value {
                    return letter
                }
            }
            return "E"
        }.joined()
    }
}
