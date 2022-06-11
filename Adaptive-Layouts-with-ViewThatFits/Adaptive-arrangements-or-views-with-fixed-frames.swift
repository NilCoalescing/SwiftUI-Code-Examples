import SwiftUI

struct AdaptiveArrangementsExample: View {
    var body: some View {
        ViewThatFits {
            HStack {
                CardStack()
            }
            VStack {
                CardStack()
            }
        }
    }
}

struct CardStack: View {
    let cardsConfigs = [
        ("sun.max", Color.yellow),
        ("cloud", Color.purple),
        ("snowflake", Color.blue)
    ]
    
    var body: some View {
        ForEach(cardsConfigs, id: \.self.0) { config in
            CardView(
                imageName: config.0,
                color: config.1
            )
        }
    }
}

struct CardView: View {
    let imageName: String
    let color: Color
    
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(color)
            .font(.system(size: 50))
            .frame(width: 200, height: 200)
            .border(color, width: 4)
    }
}
