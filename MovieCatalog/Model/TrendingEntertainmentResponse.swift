import Foundation

struct TrendingEntertainmentResponse: Codable {
    let results: [TrendingEntertainmentDetails]
}

struct TrendingEntertainmentDetails: Codable, Hashable {
    let id: Int
    let originalTitle: String? // api gives us original_title, convention in swift is originalTile
    let overview: String?
    let posterPath: String?
    let title: String?
    let voteAverage: Double?

    let identifier = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: TrendingEntertainmentDetails, rhs: TrendingEntertainmentDetails) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        return ((title?.lowercased().contains(lowercasedFilter)) != nil)
    }
}

#if DEBUG
    extension TrendingEntertainmentDetails {
        static var sampleData = [
            TrendingEntertainmentDetails(id: 0, originalTitle: "org title 0", overview: "overview 0", posterPath: nil, title: "title 0", voteAverage: 0.0),
            TrendingEntertainmentDetails(id: 1, originalTitle: "org title 1", overview: "overview 1", posterPath: nil, title: "title 1", voteAverage: 1.0),
            TrendingEntertainmentDetails(id: 2, originalTitle: "org title 2", overview: "overview 2", posterPath: nil, title: "title 2", voteAverage: 2.0),
            TrendingEntertainmentDetails(id: 3, originalTitle: "org title 3", overview: "overview 3", posterPath: nil, title: "title 3", voteAverage: 3.0),
            TrendingEntertainmentDetails(id: 4, originalTitle: "org title 4", overview: "overview 4", posterPath: nil, title: "title 4", voteAverage: 4.0),
            TrendingEntertainmentDetails(id: 5, originalTitle: "org title 5", overview: "overview 5", posterPath: nil, title: "title 5", voteAverage: 5.0),
            TrendingEntertainmentDetails(id: 6, originalTitle: "org title 6", overview: "overview 6", posterPath: nil, title: "title 6", voteAverage: 6.0),
        ]
    }
#endif
