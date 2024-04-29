import UIKit

struct FirstPhotos: Codable, Hashable {
    var image: String
}

class FirstService {
    
    //https://apingweb.com/api/rest/9833cf035fb0a79c0247bdf9766d2dee27/First
    
    func fetchFirst(completion: @escaping (Result<[FirstPhotos], NetworkErrors>) -> Void) {
        
        //https://mocki.io/v1/5f87c744-e022-4523-a5ed-6bc3aad3585c
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "mocki.io"
        urlComponents.path = "/v1/5f87c744-e022-4523-a5ed-6bc3aad3585c"
        
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

