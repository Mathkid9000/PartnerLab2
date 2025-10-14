//
//  ContentView.swift
//
//  Assignment: PartnerLab2
//  Created by:
//              Liam Christensen
//              Edgar Rosales
//  Date:       10/11/25.
//

import SwiftUI

struct ContentView: View {
    // Logic for generating a random board of paired tiles
    func generateTiles() -> [Int] {
        var possibleTiles: [Int] = Array(1..<12)
        var selectedTileTypes: [Int] = []
        for _ in 0..<8 {
            let selection = Int.random(in: 0..<possibleTiles.count)
            selectedTileTypes.append(possibleTiles[selection])
            possibleTiles.remove(at: selection)
        }
        var tiles: [Int] = []
        for _ in 0..<16 {
            let selection = Int.random(in: 0..<selectedTileTypes.count)
            let tileType = selectedTileTypes[selection]
            if tiles.contains(tileType) {
                selectedTileTypes.remove(at: selection)
            }
            tiles.append(tileType)
        }
        return tiles
    }

    static var tileUp: CardView? = nil // current flipped card -> nil if no card is flipped over
    static var completePairs: Int = 0 // amount of correctly matched pairs
    static var isProcessingClick: Bool = false // small time allocated for showing second card in pair
    var body: some View {
        let tiles = generateTiles()
        
        Text("Memory Game")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        LazyHGrid(rows:
                    [GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                     GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                     GridItem(.adaptive(minimum: 40, maximum: .infinity)),
                     GridItem(.adaptive(minimum: 40, maximum: .infinity))],
                  spacing: 0
        )
        {
            ForEach(0..<16) { i in
                CardView (image: "\(tiles[i])", id_index: i)
                    .frame(minWidth: 40, maxWidth: .infinity)
            }
        }.padding(0)
    }
}

// Implements functionality to cover and uncover cars upon tap gesture
struct CardView: View {
    var image: String
    var id_index: Int
    //var image: Int
    @State var isFaceUp: Bool = false // false: Cards covered by default, true: cards uncovered by default
    @State var isComplete: Bool = false // false: Cards have no effect, true: add an opacity effect to show that it has been paired
    
    // Logic for when a card is flipped over
    func flipCard() {
        if ContentView.isProcessingClick == true {
            return
        }
        
        if ContentView.tileUp == nil {
            ContentView.tileUp = self
            isFaceUp = true
        }
        else {
            if ContentView.tileUp!.id_index == id_index {
                return
            }

            isFaceUp = true
            if ContentView.tileUp!.image == image {
                ContentView.completePairs += 1
                isComplete = true
                ContentView.tileUp?.isComplete = true
                ContentView.tileUp = nil
            }
            else {
                ContentView.isProcessingClick = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    ContentView.tileUp!.isFaceUp = false
                    isFaceUp = false
                    ContentView.tileUp = nil
                    ContentView.isProcessingClick = false
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            let shape = ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0, y: 4)
                    .border(Color.black, width: 1)
                    .frame(width: 60, height: 60)
                    .padding(0)
                LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .init(.sRGB, red:156/255, green:79/255, blue:150/255), location: 0),
                            .init(color: .init(.sRGB, red:255/255, green:99/255, blue:85/255), location: 0.5),
                            .init(color: .init(.sRGB, red:251/255, green:169/255, blue:73/255), location: 1)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
            }
            
            
            Image(image)
                .resizable()
                .frame(width: 60, height: 60)
                .scaledToFit()
                .opacity(isComplete ? 0.5 : 1)
            
            if isFaceUp {
                shape.opacity(0)
            }
            else {
                shape.opacity(1)
            }
        }.padding()
            .onTapGesture(perform: flipCard)
        
    }
}

#Preview {
    ContentView()
}
