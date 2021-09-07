//
//  DetailsViewController.swift
//  FilmList2
//
//  Created by Tayyip Çakmak on 28.08.2021.
//
import AlamofireImage
import Alamofire
import RealmSwift
import UIKit

class favoriteFilm: Object {
    @objc dynamic var favoriteFilmTitle: String = ""
}

class DetailsViewController: UIViewController {
    
    let realm = try! Realm()
    var deletionHandler: (() -> Void)?
    var data = [favoriteFilm]()
    var selectedfavoriFilm = favoriteFilm()
    
    var titles: String!
    var backdropPath: String!
    var originalLanguage:String!
    var orginalTitle: String!
    var overview: String!
    var voteAverage: Double!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var orginalLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        responseDetail()
        favButton()
    }
    func responseDetail()  {
        AF.request(backdropPath).responseImage { (response) in
            if let images = response.value {
                self.backgroundImage.image = images
            }
        }
        languageLabel.text = "Orginal Language : \(originalLanguage.uppercased())"
        orginalLabel.text = "Orginal Name : \(orginalTitle!)"
        overviewLabel.text = "Overview : \(overview!)"
        rateLabel.text = "Rate : \(voteAverage.description)"
        data = realm.objects(favoriteFilm.self).map({$0})
    }
    func favButton() {
        selectedfavoriFilm = favoriteFilm()
        selectedfavoriFilm.favoriteFilmTitle = titles
        let favorites = realm.objects(favoriteFilm.self)
        let filterFilms = favorites.filter("favoriteFilmTitle CONTAINS \"\(selectedfavoriFilm.favoriteFilmTitle)\"")
       
        if !filterFilms.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove Fav", style: .done, target: self, action: #selector(removeFavorite))
            }else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Fav", style: .done, target: self, action: #selector(addFavorite))
            }
    }
    @objc func addFavorite() {
        selectedfavoriFilm.favoriteFilmTitle = titles
        realm.beginWrite()
        realm.add(selectedfavoriFilm)
        try! realm.commitWrite()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove Fav", style: .done, target: self, action: #selector(removeFavorite))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    @objc func removeFavorite() {
        selectedfavoriFilm = favoriteFilm()
        selectedfavoriFilm.favoriteFilmTitle = titles
        let favorites = realm.objects(favoriteFilm.self)
        let filterFilms = favorites.filter("favoriteFilmTitle CONTAINS \"\(selectedfavoriFilm.favoriteFilmTitle)\"")
        realm.beginWrite()
        realm.delete(filterFilms)
        try! realm.commitWrite()
        deletionHandler?()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Fav", style: .done, target: self, action: #selector(addFavorite))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
}
