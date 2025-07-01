
import Foundation

// MARK: - Unsplash Models
struct UnsplashResponse: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let urls: UnsplashURLs
}

struct UnsplashURLs: Decodable {
    let regular: String
}

// MARK: - Unsplash Service
class UnsplashService {
    private func getAPIKey() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "UNSPLASH_ACCESS_KEY") as? String
    }

    func fetchImage(for query: String) async throws -> URL? {
        guard let accessKey = getAPIKey() else {
            throw URLError(.userAuthenticationRequired)
        }
        
        var components = URLComponents(string: "https://api.unsplash.com/search/photos")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "1"),
            URLQueryItem(name: "client_id", value: accessKey)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(UnsplashResponse.self, from: data)

        return response.results.first.flatMap { URL(string: $0.urls.regular) }
    }
}
