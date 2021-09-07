//
//  FavoriteViewController.swift
//  FilmList2
//
//  Created by Tayyip Çakmak on 31.08.2021.
//
import RealmSwift
import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var favoriteFilmItemList: UITableView!
  
    public var favoriteFilmsItem = [favoriteFilm]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteFilmItemList.delegate = self
        favoriteFilmItemList.dataSource = self
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFilmsItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteFilmItemList.dequeueReusableCell(withIdentifier: "TableCell")!
        cell.textLabel?.text = favoriteFilmsItem[indexPath.row].favoriteFilmTitle
        return cell
    }
    @objc func refresh() {
        favoriteFilmsItem = realm.objects(favoriteFilm.self).map({$0})
        favoriteFilmItemList.reloadData()
      }
}
