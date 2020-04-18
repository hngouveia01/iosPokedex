import Foundation
import PromiseKit
import Alamofire
import UIKit


let baseURL: String = "http://pokeapi.co/api/v2"

let defaultError = NSError(domain: "PokeAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "not yet implemented."])

class RequestAPI {
    func fetchPokemon(_ pokemonId: String) -> Promise<PKMPokemon> {
        return Promise { seal in
            let URL = baseURL + "/pokemon/" + pokemonId
            AF.request(URL, method: .get).responseData { response in
                if (response.error != nil) {
                    seal.reject(response.error!)
                }

                guard let data = response.data else {
                        seal.reject(defaultError)
                        return
                }

                var pokemon: PKMPokemon? = nil

                do {
                    let decoder = JSONDecoder()
                    let decoded: PokemonDecodable = try decoder.decode(PokemonDecodable.self, from: data)
                    let sprites = PKMPokemonSprites(front: decoded.frontDefault, back: decoded.backDefault)
                    pokemon = PKMPokemon(id: decoded.id, name: decoded.name, sprites: sprites)
                } catch {
                    seal.reject(defaultError)
                }

                seal.fulfill(pokemon!)
            }.resume()
        }
    }

    func fetchPokemon(name pokename: String) -> Promise<PKMPokemon> {
        return Promise { seal in
            let URL = baseURL + "/pokemon/" + pokename
            AF.request(URL, method: .get).responseData { response in
                if (response.error != nil) {
                    seal.reject(response.error!)
                }

                guard let data = response.data else {
                        seal.reject(defaultError)
                        return
                }

                var pokemon: PKMPokemon?

                do {
                    let decoder = JSONDecoder()
                    let decoded: PokemonDecodable = try decoder.decode(PokemonDecodable.self, from: data)
                    let sprites = PKMPokemonSprites(front: decoded.frontDefault, back: decoded.backDefault)
                    pokemon = PKMPokemon(id: decoded.id, name: decoded.name, sprites: sprites)
                } catch {
                    seal.reject(defaultError)
                }
                if let pokemon = pokemon {
                    seal.fulfill(pokemon)
                }
                seal.reject(defaultError)
            }.resume()
        }
    }

    func fetchPokemonImage(imageURL: URL) -> Promise<UIImage> {
        return Promise { seal in
            AF.download(imageURL).response { response in
                if response.error == nil,
                    let imagePath = response.fileURL?.path {
                    let image = UIImage(contentsOfFile: imagePath)
                    seal.fulfill(image!)
                }

            }
        }
    }
}
