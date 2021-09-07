//
//  Film.swift
//  FilmList2
//
//  Created by Tayyip Çakmak on 24.08.2021.
//

import Foundation

struct Film: Codable {
      let backdropPath: String
      let originalLanguage, originalTitle, overview: String
      let popularity: Double
      let posterPath: String
      let title: String
      let voteAverage: Double

    enum CodingKeys: String, CodingKey {
          case backdropPath = "backdrop_path"
          case originalLanguage = "original_language"
          case originalTitle = "original_title"
          case overview, popularity
          case posterPath = "poster_path"
          case title
          case voteAverage = "vote_average"
    }
}
