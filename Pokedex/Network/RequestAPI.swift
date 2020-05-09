import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON


let baseURL: String = "http://pokeapi.co/api/v2"

let defaultError = NSError(domain: "PokeAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "not yet implemented."])

class RequestAPI {
    func fetchPokemonWith(name pokename: String) -> Promise<PKMPokemon> {
        return Promise { seal in
            let url = baseURL + "/pokemon/" + pokename
            AF.request(url, method: .get)
                .validate()
                .responseJSON { response in

                guard response.error == nil,
                    let data = response.data else {
                        seal.reject(defaultError)
                        return
                }

                let json = JSON(data)

                if let pokemonName = json["name"].string,
                    let pokemonId = json["id"].int,
                    let generalMoves = json["moves"].array,
                    let frontSpriteURL = json["sprites"]["front_default"].string,
                    let backSpriteURL = json["sprites"]["back_default"].string {

                    var battleMoves: [String] = []

                    for battleMove in generalMoves {
                        if let name = battleMove["move"]["name"].string {
                            battleMoves.append(name)
                        }
                    }
                    let sprites = PKMPokemonSprites(front: frontSpriteURL,
                                                    back: backSpriteURL)

                    let pokemon = PKMPokemon(id: pokemonId,
                                             name: pokemonName,
                                             sprites: sprites,
                                             moves: battleMoves)
                        seal.fulfill(pokemon)
                } else {
                    seal.reject(defaultError)
                }
            }.resume()
        }
}

    func fetchPokemonImage(imageURL: URL) -> Promise<Data> {
        return Promise { seal in
            AF.download(imageURL)
                .validate()
                .responseData { data in
                    if let data = data.value {
                        seal.fulfill(data)
                    }
                    seal.reject(defaultError)
                }
        }
    }
}
