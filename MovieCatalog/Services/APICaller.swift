import Foundation

// MARK: - API-MANAGER
class APICaller: APICallerProtocol {

    static let shared: APICaller = {
        let urlBuilder = URLBuilder(baseURL: API.baseURL, apiKey: API.apiKey)
        return APICaller(urlBuilder: urlBuilder)
    }()

    let urlBuilder: URLBuilderProtocol

    var apiCallCount = 0

    private init(urlBuilder: URLBuilderProtocol) {
        self.urlBuilder = urlBuilder
    }
}


// MARK: - SEARCH RESULTS
extension APICaller {

    func searchMovie(with query: String, language: String? = nil, page: Int? = nil) async throws -> [TrendingEntertainmentDetails] {
        var queryParameters: [String: String] = ["query": query]

        if let language = language {
            queryParameters["language"] = language
        }

        if let page = page {
            queryParameters["page"] = String(page)
        }
        guard let url = urlBuilder.buildURL(for: API.Endpoints.searchMovies, with: queryParameters) else {
            throw NetworkError.invalidURL
        }
        apiCallCount += 1
//        print(url) works https://api.themoviedb.org/3/search/movie?api_key=feb9855b002501ffca186a91b9e31080&query=harry

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let searchResponse = try decoder.decode(TrendingEntertainmentResponse.self, from: data)
            print("API total calls: \(apiCallCount)")
            return searchResponse.results
        } catch {
            throw NetworkError.invalidData
        }
    }
}

// MARK: - GET-TOPLIST
extension APICaller {

    func getTopMovieList(language: String? = nil, page: Int? = nil) async throws -> [TrendingEntertainmentDetails] {
        var queryParameters: [String: String] = [:]

        if let language = language {
            queryParameters["language"] = language
        }

        if let page = page {
            queryParameters["page"] = String(page)
        }

        guard let url = urlBuilder.buildURL(for: API.Endpoints.topRatedMovies, with: queryParameters) else {
            throw NetworkError.invalidURL
        }
//        print(url) works https://api.themoviedb.org/3/movie/top_rated?api_key=feb9855b002501ffca186a91b9e31080

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
