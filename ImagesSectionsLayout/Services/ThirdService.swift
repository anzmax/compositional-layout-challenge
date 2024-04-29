import UIKit


struct ThirdPhotos: Codable, Hashable {
    var image: String
}

class ThirdService {
    
    func fetchThird(completion: @escaping (Result<[ThirdPhotos], NetworkErrors>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "mocki.io"
        urlComponents.path = "/v1/c90014be-9656-485e-9772-24684a35df3d"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.emptyUrl))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                let thirdPhotos = try jsonDecoder.decode([ThirdPhotos].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(thirdPhotos))
                }
            }
            catch {
                print(error)
                completion(.failure(.parsingInvalid))
            }
            
        }.resume()
    }
}
