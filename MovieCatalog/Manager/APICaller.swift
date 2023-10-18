//
//  APICaller.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-15.
//

import Foundation

struct CONSTANTS {
    static let MOVIE_DATABASE_URL = "https://api.themoviedb.org/"
    static let API_KEY = "?api_key=feb9855b002501ffca186a91b9e31080"
}

public enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidQuery
    case invalidResponse
    case networkError(Error)
    case serializationError(Error)
    case decodingError(Error)
}

// MARK: - API

class APICaller {
    static let shared = APICaller()

    func getTopMovieList() async throws -> [TrendingEntertainmentDetails] {
        guard let url = URL(string: "\(CONSTANTS.MOVIE_DATABASE_URL)3/movie/top_rated\(CONSTANTS.API_KEY)") else {
            throw NetworkError.invalidURL
        }
        

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoder = JSONDecoder() // api gives us original_title, convention in swift is originalTile
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let trendingResponse = try decoder.decode(TrendingEntertainmentResponse.self, from: data)
            return trendingResponse.results
        } catch {
            throw NetworkError.invalidData
        }
    }
}
