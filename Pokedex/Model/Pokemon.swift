import Foundation
import Alamofire
import PromiseKit

class PKMPokemon: Codable {
    var id: Int
    var name: String
    var height: Int
    var sprites: PKMPokemonSprites

    init(id: Int,
        name: String,
         //url: String,
         //weight: Int,
         height: Int,
         sprites: PKMPokemonSprites) {
        self.id = id
        self.name = name
        //self.spriteURL = url
        self.height = height
        //self.weight = weight
        self.sprites = sprites
    }
}

class PKMPokemonSprites: Codable {
    /// The default depiction of this Pokémon from the front in battle
    var frontDefault: String

    init(frontDefault: String) {
        self.frontDefault = frontDefault
    }
//
//    /// The shiny depiction of this Pokémon from the front in battle
//    var frontShiny: String?
//
//    /// The female depiction of this Pokémon from the front in battle
//    var frontFemale: String?
//
//    /// The shiny female depiction of this Pokémon from the front
//    var frontShinyFemale: String?
//
//    /// The default depiction of this Pokémon from the back in battle
//    var backDefault: String?
//
//    /// The shiny depiction of this Pokémon from the back in battle
//    var backShiny: String?
//
//    /// The female depiction of this Pokémon from the back in battle
//    var backFemale: String?
//
//    /// The shiny female depiction of this Pokémon from the back in battle
//    var backShinyFemale: String?
}
