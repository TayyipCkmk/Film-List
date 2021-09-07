//
//  Films.swift
//  FilmList2
//
//  Created by Tayyip Çakmak on 24.08.2021.
//

import Foundation

struct Films: Decodable {
  let all: [Film]
  
  enum CodingKeys: String, CodingKey {
    case all = "results"
  }
}
