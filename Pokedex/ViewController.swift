//
//  ViewController.swift
//  Pokedex

import UIKit

class ViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

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
    @IBOutlet weak var pokeTableView: UITableView!

    var searchActive : Bool = false
    var data = ["Weedle","Bubassaur","Ekans","Metapod","Voltorb","Magmar"]
    var filtered:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        self.pokeTableView.delegate = self
        self.pokeTableView.dataSource = self
        self.pokeTableView.delegate = self
        self.search.delegate = self
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")

        let api = RequestAPI()
        api.fetchPokemon("1").done { pokemon in
            print(pokemon.name)
        }
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        search.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        search.resignFirstResponder()
        searchActive = false;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }

        self.pokeTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }

        return cell;
    }
}

