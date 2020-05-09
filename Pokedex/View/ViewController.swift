//
//  ViewController.swift
//  Pokedex

import UIKit
import Alamofire
import PromiseKit

class ViewController:  UIViewController, UISearchBarDelegate {
    // show pokemon sprite
    @IBOutlet weak var pokemonImage: UIImageView!
    // search bar to search pokemon
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var search: UISearchBar!
    // OK image button

    @IBOutlet weak var pokedexBlueLight: UIImageView!
    @IBOutlet weak var PokemonInfoTextView: UITextView!
    // tap gesture recognizer for OK image
    let tapRec = UITapGestureRecognizer()

    // make requests for pokemon API
    let api: RequestAPI = RequestAPI()

    var pokemonImagesForAnimation: Array<UIImage> = []

    var pokemon: PKMPokemon?

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Setup delegates */
        self.search.delegate = self

        // modify search bar
        let textFieldInsideUISearchBar = self.search.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.borderStyle = .line
        textFieldInsideUISearchBar?.backgroundColor = UIColor.white
        textFieldInsideUISearchBar?.textColor = .black

        // Change background colour that is
        // in front of "PUT A DESCRIPTION HERE
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")
        self.pokemonImage.layer.cornerRadius = 10
        self.pokemonImage.layer.masksToBounds = true
        self.backgroundImage.setValue(UIColor.systemRed, forKey: "backgroundColor")

        // dismiss keyboard used in search bar
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)

        self.pokemonImage.animationDuration = 1

        // no need to use captal letters here
        self.search.searchTextField.autocapitalizationType = .none
        pokedexBlueLight.makeRounded()
        pokedexBlueLight.startGlowingWithColor(color: UIColor.cyan, intensity: 1.5)
        self.search.becomeFirstResponder()
    }

    // to dismiss keyboard during search
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.search.resignFirstResponder()
    }

    // search button on keyboard is pressed.
    private func generatePokemon(_ pokemonName: String) -> PMKFinalizer {
        return // request pokemon data
            api.fetchPokemon(name: pokemonName.lowercased())
                .done { [weak self] pokemon in
                    if let `self` = self {
                        self.api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.frontDefault)!)
                            .done { frontImage in
                                //self.pokemon = pokemon
                                let outputLine = "===========================\n"
                                var output = String(outputLine)
                                output.append("name: " + pokemon.name + "\n")
                                output.append(outputLine + "\n")
                                self.PokemonInfoTextView.text = output
                                self.pokemonImagesForAnimation.append(UIImage(data: frontImage)!)
                                self.api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.backDefault)!)
                                    .done { backImage in
                                        self.pokemonImagesForAnimation.append(UIImage(data: backImage)!)
                                        self.pokemonImage.animationImages = self.pokemonImagesForAnimation
                                        self.pokemonImage.startAnimating()
                                }
                                .catch { error in
                                    print("error while fetching back image")
                                }
                        }
                        .catch { error in
                            print("error while fetching front image")
                        }
                    }
            }
            .catch { error in
                print("error while fetching pokemon")
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search.endEditing(true)
        self.pokemonImagesForAnimation.removeAll()
        self.pokemonImage.stopAnimating()
        // dont show pokemon image if nothing is typed
        if searchBar.text!.isEmpty {
            self.pokemonImage.image = nil
            return
        }

        if let pokemonName = searchBar.text {
            generatePokemon(pokemonName)
        }
    }
}

extension UIImageView {
    func makeRounded() {
        self.layer.borderWidth = 2
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.cyan.cgColor
        self.layer.borderColor = UIColor.cyan.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = false
    }
}
