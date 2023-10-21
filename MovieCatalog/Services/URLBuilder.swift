import Foundation

class URLBuilder: URLBuilderProtocol {
    let baseURL: String
    let apiKey: String

    init(baseURL: String, apiKey: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
    }

    func buildURL(for endpoint: String, with queries: [String: String] = [:]) -> URL? {
        var components = URLComponents(string: "\(baseURL)\(endpoint)")
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]

        for (key, value) in queries {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        components?.queryItems = queryItems
        return components?.url
    }
}
