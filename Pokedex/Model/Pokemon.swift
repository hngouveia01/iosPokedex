import Foundation
import Alamofire
import PromiseKit

class PKMPokemon: Codable {
    var id: Int
    var name: String
    var height: Int

    init(id: Int,
        name: String,
         //url: String,
         //weight: Int,
         height: Int) {
        self.id = id
        self.name = name
        //self.spriteURL = url
        self.height = height
        //self.weight = weight
    }
}
