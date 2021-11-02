import Foundation

enum APIURL {
    case items(URL)
    case details(URL)

    var request: URLRequest {
        switch self {
        case .items(let url), .details(let url):
            return URLRequest(url: url)
        }
    }
}

class Service<T: Decodable> {

    static func fetch(apiURL: APIURL, completion: @escaping (Result<T, APPError>) -> Void)  {

        CoreAPI.fetch(request: apiURL.request) { result in

            switch result {
            case .success(let data):

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedData = try decoder.decode(T.self, from: data)

                    completion(.success(decodedData))
                } catch {

                    completion(.failure(APPError(parsingError: error)))
                }
            case .failure(let error):

                completion(.failure(error))
            }

        }
    }
    
}

class CoreAPI {
    
    static func fetch(request: URLRequest, completion: @escaping (Result<Data, APPError>) -> Void) {

        // MARK: - Configure session
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpShouldSetCookies = false
        let session = URLSession(configuration: sessionConfiguration)

        let task = session.dataTask(with: request) { data, response, error in
            // MARK: - Handling Error:
            if let error = error {

                DispatchQueue.main.async {
                    completion(.failure(.server(error)))
                }
                return
            }

            // MARK: - Handling Response:
            if let httpResponse = response as? HTTPURLResponse, 300...500 ~= httpResponse.statusCode {

                DispatchQueue.main.async {
                    completion(.failure(.statusCode((httpResponse.statusCode))))
                }
                return
            }

            // MARK: - Handling Data:
            guard let data = data else {

                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }

            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
}
