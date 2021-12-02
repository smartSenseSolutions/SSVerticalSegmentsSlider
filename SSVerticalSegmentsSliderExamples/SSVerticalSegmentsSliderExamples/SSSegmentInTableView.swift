//
//  SSSegmentInTableView.swift
//  SSSegmentSliderExamples
//
//  Created by smartsense-kiran on 26/11/21.
//

import SwiftUI
import SSVerticalSegmentsSlider
        
struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let type: String
    let color: Color
    var selectedProgress: Int
}

class PokemonModel: ObservableObject {
    @Published var pokemonList: [Pokemon]
    init() {
        self.pokemonList = [
            Pokemon(id: 0, name: "Charmander", type: "Fire", color: .red, selectedProgress: 2),
            Pokemon(id: 1, name: "Squirtle", type: "Water", color: .blue, selectedProgress: 3),
            Pokemon(id: 2, name: "Bulbasaur", type: "Grass", color: .green, selectedProgress: 2),
            Pokemon(id: 3, name: "Pikachu", type: "Electric", color: .yellow, selectedProgress: 2),
            Pokemon(id: 4, name: "Charizard", type: "Fire", color: .red, selectedProgress: 2),
            Pokemon(id: 5, name: "Mewtwo", type: "Psychic", color: .blue, selectedProgress: 2),
            Pokemon(id: 6, name: "Lucario", type: "Fighting", color: .red, selectedProgress: 2),
            Pokemon(id: 7, name: "Gardevoir", type: "Fairy", color: .orange, selectedProgress: 2),
            Pokemon(id: 8, name: "Sylveon", type: "Cute Charm", color: .yellow, selectedProgress: 2),
            Pokemon(id: 9, name: "Mew", type: "Psychic", color: .blue, selectedProgress: 2),
            Pokemon(id: 10, name: "Jigglypuff", type: "Fairy", color: .orange, selectedProgress: 2),
            Pokemon(id: 11, name: "Greninja", type: "Water", color: .blue, selectedProgress: 2),
        ]
    }
}

struct SSSegmentInTableView: View {
    @ObservedObject var dataModel = PokemonModel()
    
    var body: some View {
        List.init($dataModel.pokemonList) { $pokemonInstance in
            VStack {
                HStack {
                    SSVerticalSegmentsSlider(
                        selectedProgress: $pokemonInstance.selectedProgress,
                        layoutOption: .straight(40),
                        heightOfSegments: 20,
                        gapBetweenSegments: 2,
                        cornerRadiusForAllSegments: 0.0,
                        cornerRadiusForFirstAndLastSegmentCornersOnly: 10
                        )
                        .cornerRadius(12)
                    Text.init(pokemonInstance.name)
                    Text.init(pokemonInstance.type).foregroundColor(pokemonInstance.color)
                    
                }
                Spacer()
                    .frame(height: 8)
            }
        }
    }
}

struct SSSegmentInTableView_Previews: PreviewProvider {
    static var previews: some View {
        SSSegmentInTableView()
    }
}
