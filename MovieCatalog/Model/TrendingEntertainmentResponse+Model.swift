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

