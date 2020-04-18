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

    @IBOutlet weak var pokedexBlueLight: UIImageView!
    @IBOutlet weak var PokemonInfoTextView: UITextView!
    // tap gesture recognizer for OK image
    let tapRec = UITapGestureRecognizer()

    // make requests for pokemon API
    var api: RequestAPI = RequestAPI()

    var pokemonImagesForAnimation: Array<UIImage> = []

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
        pokedexBlueLight.makeRounded()
        pokedexBlueLight.startGlowingWithColor(color: UIColor.cyan, intensity: 1.5)
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
        self.search.endEditing(true)
        self.pokemonImagesForAnimation.removeAll()
        self.pokemonImage.stopAnimating()
        // dont show pokemon image if nothing is typed
        if searchBar.text!.isEmpty {
            self.pokemonImage.image = nil
            return
        }

        if let pokemonName = searchBar.text {
            //self.pokemonImage.image = nil

            let pokeNameLower: String = pokemonName.lowercased()

            // request pokemon sprite
            api.fetchPokemon(name: pokeNameLower).then { pokemon in
                self.api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.frontDefault)!)
            }.done { image in
                //self.pokemonImage.image = image
                self.pokemonImagesForAnimation.append(image)
                self.api.fetchPokemon(name: pokeNameLower).then { pokemon in
                    self.api.fetchPokemonImage(imageURL: URL(string: pokemon.sprites.backDefault)!)
                }.done { image in
                    //self.pokemonImage.image = image
                    self.pokemonImagesForAnimation.append(image)
                    self.pokemonImage.animationImages = self.pokemonImagesForAnimation
                    self.pokemonImage.animationDuration = 1
                    self.pokemonImage.animationRepeatCount = 100
                    self.pokemonImage.startAnimating()

                }.catch { error in
                    print("Cant find pokemon")
                    self.pokemonImage.image = nil
                }
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
private var GLOWVIEW_KEY = "GLOWVIEW"

extension UIView {
    var glowView: UIView? {
        get {
            return objc_getAssociatedObject(self, &GLOWVIEW_KEY) as? UIView
        }
        set(newGlowView) {
            objc_setAssociatedObject(self, &GLOWVIEW_KEY, newGlowView!, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func startGlowingWithColor(color:UIColor, intensity:CGFloat) {
        self.startGlowingWithColor(color: color, fromIntensity: 0.1, toIntensity: intensity, repeat: true)
    }

    func startGlowingWithColor(color:UIColor, fromIntensity:CGFloat, toIntensity:CGFloat, repeat shouldRepeat:Bool) {
        // If we're already glowing, don't bother
        if self.glowView != nil {
            return
        }

        // The glow image is taken from the current view's appearance.
        // As a side effect, if the view's content, size or shape changes,
        // the glow won't update.
        var image:UIImage

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale); do {
            self.layer.render(in: UIGraphicsGetCurrentContext()!)

            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))

            color.setFill()

            path.fill(with: .sourceAtop, alpha:1.0)


            image = UIGraphicsGetImageFromCurrentImageContext()!
        }

        UIGraphicsEndImageContext()

        // Make the glowing view itself, and position it at the same
        // point as ourself. Overlay it over ourself.
        let glowView = UIImageView(image: image)
        glowView.center = self.center
        self.superview!.insertSubview(glowView, aboveSubview:self)

        // We don't want to show the image, but rather a shadow created by
        // Core Animation. By setting the shadow to white and the shadow radius to
        // something large, we get a pleasing glow.
        glowView.alpha = 0
        glowView.layer.shadowColor = color.cgColor
        glowView.layer.shadowOffset = CGSize.zero
        glowView.layer.shadowRadius = 10
        glowView.layer.shadowOpacity = 1.0

        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromIntensity
        animation.toValue = toIntensity
        animation.repeatCount = shouldRepeat ? .infinity : 0 // HUGE_VAL = .infinity / Thanks http://stackoverflow.com/questions/7082578/cabasicanimation-unlimited-repeat-without-huge-valf
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        glowView.layer.add(animation, forKey: "pulse")

        // Finally, keep a reference to this around so it can be removed later
        self.glowView = glowView
    }

    func glowOnceAtLocation(point: CGPoint, inView view:UIView) {
        self.startGlowingWithColor(color: UIColor.white, fromIntensity: 0, toIntensity: 0.6, repeat: false)

        self.glowView!.center = point
        view.addSubview(self.glowView!)

        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }
    }

    func glowOnce() {
        self.startGlowing()

        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }

    }

    // Create a pulsing, glowing view based on this one.
    func startGlowing() {
        self.startGlowingWithColor(color: UIColor.white, intensity:0.6);
    }

    // Stop glowing by removing the glowing view from the superview
    // and removing the association between it and this object.
    func stopGlowing() {
        self.glowView!.removeFromSuperview()
        self.glowView = nil
    }

}
