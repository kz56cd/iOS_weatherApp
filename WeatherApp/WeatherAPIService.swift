
import Foundation
import Moya

enum WeatherAPIService {
    case getWeather(latitude: Double, longitude: Double, timezone: String)
}

extension WeatherAPIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.open-meteo.com/v1")!
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/forecast"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWeather:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getWeather(let latitude, let longitude, let timezone):
            let parameters: [String: Any] = [
                "latitude": latitude,
                "longitude": longitude,
                "daily": "weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_mean",
                "timezone": timezone
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }

    var sampleData: Data {
        return Data() // For testing purposes
    }
}
