import UIKit


struct ThirdPhotos: Codable, Hashable {
    var image: String
}

enum ThirdNetworkError: Error {
   case emptyUrl
   case emptyJson
   case parsingInvalid
}

class ThirdService {
    
    //https://apingweb.com/api/rest/646474650dcd163dd2852dafb3fb64db13/Third
    
    func fetchThird(completion: @escaping (Result<[ThirdPhotos], ThirdNetworkError>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/646474650dcd163dd2852dafb3fb64db13/Third"
        
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
