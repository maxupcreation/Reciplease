    import UIKit
    
    final class RequestService {
        // MARK: - Properties
        
        private let session: AlamofireSessions
        
        // MARK: - Initializer
        
        init(session: AlamofireSessions = RecipeSearchSession()) {
            self.session = session
        }
        
        // MARK: - Management
        
        func getData(food:String,callback: @escaping (Result<RecipeSearchDataStruct, RecipeError>) -> Void) {
            
            
            guard let mainUrl = URL(string:"https://api.edamam.com/search?") else {return}
            
            let parameters = [("q",food),("app_id","4cd6a87a"),("app_key","ec8a043cd61e4611c5f52cc748eacb01"),("from",0),("to",10),("calories","0-1000")] as [(String, Any)]?
            
            let url = encode(baseUrl: mainUrl, with: parameters)
            session.request(url: url) { dataResponse in
                guard let data = dataResponse.data else {
                    callback(.failure(.noData))
                    return
                }
                guard dataResponse.response?.statusCode == 200 else {
                    print(data)
                    callback(.failure(.invalidResponse))
                    return
                }
                guard let dataDecoded = try? JSONDecoder().decode(RecipeSearchDataStruct.self, from: data) else {
                    callback(.failure(.undecodableData))
                    return
                }
                callback(.success(dataDecoded))
            }
        }
        
        
        private func encode(baseUrl: URL, with parameters: [(String, Any)]?) -> URL {
            guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false), let parameters = parameters, !parameters.isEmpty else { return baseUrl }
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            guard let url = urlComponents.url else { return baseUrl }
            print(url)
            return url
        }
        
        enum RecipeError: Error, CustomStringConvertible {
            
            case noData, invalidResponse, undecodableData
       
        var description:String{
            switch self {
            case .noData:
                return "There is no data !"
            case .invalidResponse:
                return "Response status is incorrect !"
            case .undecodableData:
                return "Data can't be decoded !"
            }
        }
            
        }
        
    }
