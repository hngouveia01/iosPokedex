import Foundation
import Alamofire
import PromiseKit

class PKMPokemon {
    var id: Int
    var name: String
    var sprites: PKMPokemonSprites

    init(id: Int,
        name: String,
        sprites: PKMPokemonSprites) {
        self.id = id
        self.name = name
        self.sprites = sprites
    }
}

struct PokemonDecodable: Decodable {
    var id: Int
    var name: String
    var frontDefault: String
    var backDefault: String

    enum CodingKeys: String, CodingKey {
        case id, sprites, name
    }

    enum SpritesCodingKeys: String, CodingKey {
        case front_default, back_default
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let sprites = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
        frontDefault = try sprites.decode(String.self, forKey: .front_default)
        backDefault = try sprites.decode(String.self, forKey: .back_default)
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
