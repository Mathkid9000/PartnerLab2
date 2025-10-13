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
                CardView (image: "\(tiles[i])")
                    .frame(minWidth: 60, maxWidth: .infinity)
            }
        }.padding(5)
    }
}

// Implements functionality to cover and uncover cars upon tap gesture
struct CardView: View {
    var image: String
    //var image: Int
    @State var isFaceUp: Bool = false // false: Cards covered by default, true: cards uncovered by default
    var body: some View {
        ZStack {
            let shape = Rectangle().foregroundColor(.blue)
                .frame(width: 70.0, height: 70.0)
                //.padding()
            
            Image(image)
                .resizable()
                .frame(width: 50, height: 50)
                .scaledToFit()
                //.padding(5)
            
            if isFaceUp {
                shape.opacity(0)
            }
            else {
                shape.opacity(1)
            }
        }.padding()
            .onTapGesture {
                isFaceUp = !isFaceUp
            }
        
    }
}

#Preview {
    ContentView()
}
