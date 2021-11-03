import Foundation

class CoreAPI {

    static func fetch(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {

        // MARK: - Configure session
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.httpShouldSetCookies = false
        let session = URLSession(configuration: sessionConfiguration)

        let task = session.dataTask(with: request) { data, response, error in
            // MARK: - Handling Error:
            if let error = error {

                DispatchQueue.main.async {
                    completion(.failure(.serverError(error)))
                }
                return
            }

            // MARK: - Handling Response:
            if let httpResponse = response as? HTTPURLResponse, 300...500 ~= httpResponse.statusCode {

                DispatchQueue.main.async {
                    completion(.failure(.badResponse))
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
