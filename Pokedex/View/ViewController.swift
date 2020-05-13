//
//  ViewController.swift
//  Pokedex

import UIKit
import Alamofire
import PromiseKit

class ViewController:  UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    // show pokemon sprite
    @IBOutlet weak var pokemonImage: UIImageView!
    // search bar to search pokemon
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var pokedexBlueLight: UIImageView!
    @IBOutlet weak var PokemonInfoTextView: UITextView!
    @IBOutlet weak var infoPokemon: UITableView!

    // tap gesture recognizer for OK image
    let tapRec = UITapGestureRecognizer()
    // make requests for pokemon API
    let api: RequestAPI = RequestAPI()
    var pokemonImagesForAnimation: Array<UIImage> = []
    var pokemon: PKMPokemon?
    let backgroundQueue = DispatchQueue.global(qos: .background)

    // Data model: These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]

    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        /* Setup delegates */
        self.search.delegate = self
        // Register the table view cell class and its reuse id
        self.infoPokemon.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        // This view controller itself will provide the delegate methods and row data for the table view.
        infoPokemon.delegate = self
        infoPokemon.dataSource = self

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
        //pokedexBlueLight.makeRounded()
        //pokedexBlueLight.startGlowingWithColor(color: UIColor.cyan, intensity: 1.5)
        self.search.becomeFirstResponder()

        self.pokemon = PKMPokemon()

    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.infoPokemon.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!

        // set the text from the data model
        cell.textLabel?.text = self.animals[indexPath.row]

        return cell
    }

    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    // to dismiss keyboard during search
    @objc func singleTap(sender: UITapGestureRecognizer) {
        self.search.resignFirstResponder()
    }

    @IBAction func downButtonPressed(_ sender: Any) {
        print("DOWN button pressed")
        self.pokemonImage.animationImages?.removeAll()
        self.pokemonImage.stopAnimating()

        let id = "\((pokemon!.id + 1) ?? 1)"
        pokemon = nil

        generatePokemonWith(name: id)
    }
    @IBAction func upButtonPressed(_ sender: Any) {
        print("UP button pressed")
        self.pokemonImage.animationImages?.removeAll()
        self.pokemonImage.stopAnimating()

        let id = "\((pokemon!.id - 1) ?? 1)"
        pokemon = nil

        generatePokemonWith(name: id)
    }
    // search button on keyboard is pressed.
    private func generatePokemonWith(name: String) -> Void {

        self.pokemonImage.stopAnimating()
        self.pokemonImagesForAnimation.removeAll()
        pokemon = PKMPokemon(name: name.lowercased())
        self.pokemonImage.animationImages?.removeAll()

        firstly {
            api.fetchPokemonWith(name: name)
                .done(on: self.backgroundQueue) { pokeResult in
                    self.pokemon = pokeResult
                }
        }.then(on: backgroundQueue) { _ in
            self.api.fetchPokemonImage(imageURL: URL(string: (self.pokemon?.sprites.frontDefault)!)!)
                .done(on: self.backgroundQueue) { frontImage in
                    self.pokemonImagesForAnimation.append(UIImage(data: frontImage)!)
                }
        }.then(on: backgroundQueue) { _ in
            self.api.fetchPokemonImage(imageURL: URL(string: (self.pokemon?.sprites.backDefault)!)!)
        }.done(on: DispatchQueue.main) { backImage in
            self.pokemonImagesForAnimation.append(UIImage(data: backImage)!)
            self.pokemonImage.animationImages = self.pokemonImagesForAnimation
        }.ensure(on: DispatchQueue.main) {
            self.pokemonImage.startAnimating()
        }.catch { error in
            print("Error while downloading pokemon data")
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
            generatePokemonWith(name: pokemonName)
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

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
