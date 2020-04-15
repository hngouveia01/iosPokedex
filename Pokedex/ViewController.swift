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
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.search.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.isEmpty {
            self.pokemonImage.image = nil
            searchBar.endEditing(true)
            searchActive = false
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
        searchActive = false
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

