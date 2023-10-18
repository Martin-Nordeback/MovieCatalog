//
//  SearchResultsViewController.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-17.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var selectedTitle: String?
    private lazy var movies = [TrendingEntertainmentDetails]()
//    private lazy var movies = TrendingEntertainmentDetails.sampleData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        
    }
   
    func filteredResult(with filter: String? = nil, limit: Int? = nil) -> [TrendingEntertainmentDetails] {
        let filtered = movies.filter { $0.contains(filter)}
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
}
