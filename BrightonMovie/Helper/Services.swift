//
//  Services.swift
//  BrightonMovie
//
//  Created by Ricky Austin on 28/12/21.
//

import Foundation

enum DatabaseErrorHandle: Error {
    case failedToFetch
    case invalidResponse
    case failedToDecode
    case noData
    case invalidData
}

//MARK: - Url Service
/// Tools to build URL data into model
class UrlService{
    
    static let shared = UrlService()
    
    enum UrlMethod{
        case get, post(_ param: [String: Any]?)
    }
    
    func buildPath(path: String)->DataConvert{
        let url = URL(string: "http://www.omdbapi.com/?\(path)&apikey=daecb257")!
        return DataConvert(url: url)
    }
    
    class DataConvert{
        private let url: URL
       
        init(url: URL){
            self.url = url
        }
        
        func decode<T: Decodable>(_ T: T.Type, completion: @escaping (Result<T,Error>)->Void){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request){data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      error == nil else {
                          completion(.failure(DatabaseErrorHandle.invalidData))
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    completion(.failure(DatabaseErrorHandle.invalidResponse))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(T, from: data)
                    completion(.success(decoded))
                } catch let error {
                    print(self.url)
                    completion(.failure(error))
                }
            }.resume()
        }
    
    }
    
}
