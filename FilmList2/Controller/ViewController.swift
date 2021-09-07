//
//  ViewController.swift
//  FilmList2
//
//  Created by Tayyip Çakmak on 24.08.2021.
//
import Alamofire
import AlamofireImage
import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var uiCollectionView: UICollectionView!

    let baseUrl = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503"
    let posterUrl = "https://image.tmdb.org/t/p/w500"
    var titles: [String] = []
    var posters: [String] = []
    var backdropPath: [String] = []
    var originalLanguage: [String] = []
    var orginalTitle: [String] = []
    var overview: [String] = []
    var voteAverage: [Double] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFilms()
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        uiCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    func fetchFilms() {
        let request = AF.request(baseUrl)
        request.responseDecodable(of: Films.self) { [self] (response) in
        guard let films = response.value else { return }
            for film in films.all {
                titles.append(film.title)
                posters.append(film.posterPath)
                backdropPath.append(film.backdropPath)
                originalLanguage.append(film.originalLanguage)
                orginalTitle.append(film.originalTitle)
                overview.append(film.overview)
                voteAverage.append(film.voteAverage)
            }
                self.uiCollectionView.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            cell.uiLabel.text = titles[indexPath.row]
        let image = posterUrl+posters[indexPath.row]
        
        AF.request(image).responseImage { (response) in
            if let images = response.value {
                cell.uiImage.image = images
            }
        }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: 200, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            
            controller.titles = titles[indexPath.row]
            controller.backdropPath = posterUrl+backdropPath[indexPath.row]
            controller.originalLanguage = originalLanguage[indexPath.row]
            controller.orginalTitle = orginalTitle[indexPath.row]
            controller.overview = overview[indexPath.row]
            controller.voteAverage = voteAverage[indexPath.row]
            
            controller.navigationItem.largeTitleDisplayMode = .never
            controller.title = titles[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
    }
}


