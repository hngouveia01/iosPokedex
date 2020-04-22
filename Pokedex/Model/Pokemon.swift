import Foundation
import Alamofire
import PromiseKit

class PKMPokemon {
    var id: Int
    var name: String
    var sprites: PKMPokemonSprites
    var moves: [String]

    init(id: Int,
        name: String,
        sprites: PKMPokemonSprites,
        moves: [String]) {
        self.id = id
        self.name = name
        self.sprites = sprites
        self.moves = moves
    }
}

class PKMPokemonSprites: Codable {
    var frontDefault: String
    var backDefault: String

    init(front frontDefault: String, back backDefault: String) {
        self.frontDefault = frontDefault
        self.backDefault = backDefault
    }
}
