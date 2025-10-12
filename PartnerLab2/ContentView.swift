//
//  ContentView.swift
//  PartnerLab2
//
//  Created by Mac User on 10/11/25.
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
        LazyHGrid(rows: [GridItem(.fixed(80)),GridItem(.fixed(80)),GridItem(.fixed(80)),GridItem(.fixed(80))]) {
            ForEach(0..<16) { i in
                VStack{
                    Image("\(tiles[i])").resizable()
                        .frame(width:50,height:50)
                        .padding(15)
                        .onTapGesture {
                            print("Card tapped")
                        }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
