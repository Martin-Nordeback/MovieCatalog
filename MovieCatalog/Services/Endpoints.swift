//
//  Endpoints.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-20.
//

import Foundation

struct API {
    static let baseURL = "https://api.themoviedb.org/"
    static let apiKey = ""

    // add more here endpoints
    enum Endpoints {
        static let topRatedMovies = "3/movie/top_rated"
        static let searchMovies = "3/search/movie?query"
    }
}
