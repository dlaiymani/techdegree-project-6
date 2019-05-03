//
//  AwakensAPIClient.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class AwakensAPIClient {
    var downloader = JSONDownloader()
    
    // This methods
    func searchForData(with endpoint: Endpoint, forEntity entity: Entity, completion: @escaping ([AwakenData], Int?, AwakensError?) -> Void) {
        
        getNumberOfElements(with: endpoint) { (nbOfElements, error) in
            guard let nbOfElements = nbOfElements else {
                completion([], nil, error)
                return
            }
            
            let nbPages = Int(ceil(Double(nbOfElements) / 10.0))
            for i in 1...nbPages {
                let endpoint = Awakens.search(entity: entity, page: i)
                
                self.performRequest(with: endpoint) { (results, error) in
                    guard let results = results else {
                        completion([], nil, error)
                        return
                    }
                    
                    switch entity {
                    case .people:
                        let data = results.compactMap({ People(json: $0) })
                        completion(data, nbOfElements, nil)
                    case .vehicles:
                        let data = results.compactMap({ Vehicle(json: $0) })
                        completion(data, nbOfElements, nil)
                    case .starships:
                        let data = results.compactMap({ Starship(json: $0) })
                        completion(data, nbOfElements, nil)
                    }
                }
            }
        }
    }
    
    // This method dowloads and returns the number of elements of a search request i.e. the count field in our case.
    private func getNumberOfElements(with endpoint: Endpoint, completion: @escaping (Int?, AwakensError?) -> Void) {
        
        let task = downloader.jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let nbOfElements = json["count"] as? Int else {
                    completion(nil, .jsonParsingFailure(message: "JSON does not contains count"))
                    return
                }
                
                completion(nbOfElements, nil)
            }
        }
        task.resume()
    }
    
    typealias Results = [[String: Any]]
    // This method download and returns the results of a request search i.e. the results fields in our case
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, AwakensError?) -> Void) {
        
        let task = downloader.jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonParsingFailure(message: "JSON does not contains results"))
                    return
                }
                completion(results, nil)
            }
        }
        task.resume()
    }
    
    
    // This method performs a lookup request with an url in parameter.
    // This method is used to get home, starship and vehicles of a people
    func lookupData(withId lookupUrl: String, completion: @escaping (String?, AwakensError?) -> Void) {
        performDataRequest(with: lookupUrl) { (result, error) in
            guard let result = result else {
                completion(nil, error)
                return
            }
            completion(result, nil)
        }
    }
    
    
    // This method download the contents of the name field for a lookup request
    private func performDataRequest(with endpoint: String, completion: @escaping (String?, AwakensError?) -> Void) {
        
        guard let requestURL = URL(string: endpoint) else {
            completion(nil, .invalidData)
            return
        }
        
       let request = URLRequest(url: requestURL)
        
        let task = downloader.jsonTask(with: request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                
                guard let results = json["name"] as? String else {
                    completion(nil, .jsonParsingFailure(message: "JSON does not contains name"))
                    return
                }
                
                completion(results, nil)
            }
        }
        task.resume()
    }
}
