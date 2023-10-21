
import Foundation

protocol URLBuilderProtocol {
    func buildURL(for endpoint: String, with queries: [String: String]) -> URL?
}

