//
//  ViewController.swift
//  Pokedex

import UIKit
import Alamofire

class ViewController:  UIViewController, UISearchBarDelegate {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("test")
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("text")
//        return 2
//    }

    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var search: UISearchBar!

    var searchActive : Bool = false
//    var data = ["Weedle","Bubassaur","Ekans","Metapod","Voltorb","Magmar"]
//    var filtered:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        self.search.delegate = self
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")

        let api = RequestAPI()
        api.fetchPokemon("1").then { pokemon in
            api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.frontDefault)!)
        }.done { image in
            self.pokemonImage.image = image
        }.catch { error in
            print("Cant find pokemon")
        }
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //search.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //search.resignFirstResponder()
        searchActive = false;
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
        print("GO")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

