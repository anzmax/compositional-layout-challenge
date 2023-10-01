import UIKit

struct FirstPhotos: Codable, Hashable {
    var image: String
}

enum FirstNetworkError: Error {
   case emptyUrl
   case emptyJson
   case parsingInvalid
}

class FirstService {
    
    //https://apingweb.com/api/rest/9833cf035fb0a79c0247bdf9766d2dee27/First
    
    func fetchFirst(completion: @escaping (Result<[FirstPhotos], FirstNetworkError>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "apingweb.com"
        urlComponents.path = "/api/rest/9833cf035fb0a79c0247bdf9766d2dee27/First"
        
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
                
                let firstPhotos = try jsonDecoder.decode([FirstPhotos].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(firstPhotos))
                }
            }
            catch {

                print(error)
                completion(.failure(.parsingInvalid))
            }
            
        }.resume()
    }
}

