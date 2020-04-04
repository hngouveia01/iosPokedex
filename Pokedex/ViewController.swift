//
//  ViewController.swift
//  Pokedex

import UIKit
import Alamofire

class ViewController:  UIViewController, UISearchBarDelegate {
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var search: UISearchBar!

    var searchActive: Bool = false
    var api: RequestAPI = RequestAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        self.search.delegate = self
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")
    }

    // every key pressed
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//
//        self.pokeTableView.reloadData()
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            self.pokemonImage.image = nil
            return
        }
        if let pokemonName = searchBar.text
        {
            self.pokemonImage.image = nil
            let pokeNameLower: String = pokemonName.lowercased()
            api.fetchPokemon(name: pokeNameLower).then { pokemon in
                self.api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.frontDefault)!)
            }.done { image in
                self.pokemonImage.image = image
            }.catch { error in
                print("Cant find pokemon")
                self.pokemonImage.image = nil
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

