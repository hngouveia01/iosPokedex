import Foundation
import PromiseKit
import Alamofire


let baseURL: String = "http://pokeapi.co/api/v2"

class RequestAPI {
    func fetchPokemon(_ pokemonId: String) -> Promise<PKMPokemon> {
        return Promise { seal in
            let URL = baseURL + "/pokemon/" + pokemonId
            AF.request(URL, method: .get).responseData { response in
                if (response.error != nil) {
                    seal.reject(response.error!)
                }

                guard let data = response.data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        let err = NSError(
                        domain: "PokeAPI",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "not yet implemented."])
                        seal.reject(err)
                        return
                }

                let object = json as? [String: Any]
                let identity = object!["id"] as! Int
                let pokemonName = object!["name"] as! String
                let pokemonHeight = object!["height"] as! Int

                //let weight = object!["weight"] as! Int
                //let sprites = object!["sprites"] as? [String: Any]
                //let url = sprites!["front_default"]
                let pokemon = PKMPokemon(id: identity, name: pokemonName, height: pokemonHeight)

                seal.fulfill(pokemon)

            }.resume()
        }

    }
}
