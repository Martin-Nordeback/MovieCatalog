
import Foundation

protocol APICallerProtocol {
    func searchMovie(with query: String, language: String?, page: Int?) async throws -> [TrendingEntertainmentDetails]
    func getTopMovieList(language: String?, page: Int?) async throws -> [TrendingEntertainmentDetails]
}
