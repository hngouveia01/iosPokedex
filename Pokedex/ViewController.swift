//
//  ViewController.swift
//  Pokedex

import UIKit
import Alamofire

class ViewController:  UIViewController, UISearchBarDelegate {
    // show pokemon sprite
    @IBOutlet weak var pokemonImage: UIImageView!
    // search bar to search pokemon
    @IBOutlet weak var search: UISearchBar!
    // OK image button
    @IBOutlet weak var okUImage: UIImageView!

    // tap gesture recognizer for OK image
    let tapRec = UITapGestureRecognizer()

    // make requests for pokemon API
    var api: RequestAPI = RequestAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Setup delegates */
        self.search.delegate = self

        // Change background colour that is
        // in front of "PUT A DESCRIPTION HERE
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")

        // connect tap gesture function for OK button Image
        tapRec.addTarget(self, action: #selector(self.tappedView(sender:)))
        okUImage.addGestureRecognizer(tapRec)
        okUImage.isUserInteractionEnabled = true;

        // dismiss keyboard used in search bar
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)

        // no need to use captal letters here
        self.search.searchTextField.autocapitalizationType = .none
    }

    @objc func tappedView(sender: UITapGestureRecognizer){
        print("OK button tapped")
    }

    // to dismiss keyboard during search
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.search.resignFirstResponder()
    }

    // search button on keyboard is pressed.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // dont show pokemon image if nothing is typed
        if searchBar.text!.isEmpty {
            self.pokemonImage.image = nil
            return
        }

        if let pokemonName = searchBar.text {
            self.pokemonImage.image = nil

            let pokeNameLower: String = pokemonName.lowercased()

            // request pokemon sprite
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

