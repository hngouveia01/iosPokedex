//
//  ViewController.swift
//  Pokedex

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pokemonImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonImage.setValue(UIColor.systemGreen, forKey: "backgroundColor")
    }


}

