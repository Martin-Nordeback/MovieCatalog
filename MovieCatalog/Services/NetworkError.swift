//
//  NetworkError.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-20.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidQuery
    case invalidResponse
    case networkError(Error)
    case serializationError(Error)
    case decodingError(Error)
}
