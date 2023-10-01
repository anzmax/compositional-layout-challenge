import UIKit

struct SecondPhotos: Codable, Hashable {
    var image: String
}

enum SecondNetworkError: Error {
   case emptyUrl
   case emptyJson
   case parsingInvalid
}

class SecondService {
    
    //https://apingweb.com/api/rest/39449ad0dc08dbd65b3a76e4dffd5aab5/Second
    
    func fetchSecond(completion: @escaping (Result<[SecondPhotos], SecondNetworkError>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/39449ad0dc08dbd65b3a76e4dffd5aab5/Second"
        
        guard let url = urlComponents.url else {
            return completion(.failure(.emptyUrl))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let urlSession = URLSession(configuration: .default)
        urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                
                let secondPhotos = try jsonDecoder.decode([SecondPhotos].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(secondPhotos))
                }
            }
            catch {
                print(error)
                completion(.failure(.parsingInvalid))
            }
            
        }.resume()
    }
}

