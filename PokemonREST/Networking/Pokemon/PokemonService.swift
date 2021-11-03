import Foundation

enum PokemonAPIURL {
    case items(URL)
    case details(URL)

    var request: URLRequest {
        switch self {
        case .items(let url), .details(let url):
            return URLRequest(url: url)
        }
    }
}

class PokemonService<T: Decodable> {

    static func fetch(apiURL: PokemonAPIURL, completion: @escaping (Result<T, APIError>) -> Void)  {

        CoreAPI.fetch(request: apiURL.request) { result in

            switch result {
            case .success(let data):

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(T.self, from: data)

                    completion(.success(decodedData))
                } catch {

                    completion(.failure(APIError(decodingError: error)))
                }
            case .failure(let error):

                completion(.failure(error))
            }

        }
    }

}
