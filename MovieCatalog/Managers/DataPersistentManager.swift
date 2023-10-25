//
//  DataPersistentManager.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-22.
//

import CoreData
import Foundation
import UIKit

class DataPersistentManager {

    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }

    static let shared = DataPersistentManager()

    func saveMoveWith(model: TrendingEntertainmentDetails, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext

        let trendingEntertainmentDetails = TrendingEntertainmentDetailsEntity(context: context)

        trendingEntertainmentDetails.id = Int64(model.id)
        trendingEntertainmentDetails.title = model.title
        trendingEntertainmentDetails.originalTitle = model.originalTitle
        trendingEntertainmentDetails.overview = model.overview
        trendingEntertainmentDetails.posterPath = model.posterPath
        trendingEntertainmentDetails.voteAverage = model.voteAverage ?? 0.0

        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }

    func fetchingMoviesFromDataBase(completion: @escaping (Result<[TrendingEntertainmentDetailsEntity], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<TrendingEntertainmentDetailsEntity>
        
        request = TrendingEntertainmentDetailsEntity.fetchRequest()
        
        do {
           let result =  try context.fetch(request)
            completion(.success(result))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: TrendingEntertainmentDetailsEntity, completion: @escaping (Result<Void, Error>)-> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) 
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))

        }
    }
}
