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
                        break
                        
                    }
                }
                
            }
            
        }
        
    }


    func searchForCharacters(with endpoint: Endpoint, completion: @escaping ([AwakenData], Int?, AwakensError?) -> Void) {
        
        getNumberOfElements(with: endpoint) { (nbOfElements, error) in
            guard let nbOfElements = nbOfElements else {
                completion([], nil, error)
                return
            }
            
            let nbPages = Int(ceil(Double(nbOfElements) / 10.0))
            for i in 1...nbPages {
                let endpoint = Awakens.search(entity: .people, page: i)
                
                self.performRequest(with: endpoint) { (results, error) in
                    guard let results = results else {
                        completion([], nil, error)
                        return
                    }
                    
                    let peoples = results.flatMap({ People(json: $0) })
                    completion(peoples, nbOfElements, nil)
                }
                
            }
           
        }
        
    }

   
    
    func searchForVehicles(with endpoint: Endpoint, completion: @escaping ([AwakenData], Int?, AwakensError?) -> Void) {
        getNumberOfElements(with: endpoint) { (nbOfElements, error) in
            guard let nbOfElements = nbOfElements else {
                completion([], nil, error)
                return
            }
            
            let nbPages = Int(ceil(Double(nbOfElements) / 10.0))
            for i in 1...nbPages {
                let endpoint = Awakens.search(entity: .vehicles, page: i)
                
                self.performRequest(with: endpoint) { (results, error) in
                    guard let results = results else {
                        completion([], nil, error)
                        return
                    }
                    
                    let vehicles = results.flatMap({ Vehicle(json: $0) })
                    completion(vehicles, nbOfElements, nil)
                }
                
            }
            
        }
        
    }
    
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
    
    
    
    func lookupHome(withId homeUrl: String, completion: @escaping (String?, AwakensError?) -> Void) {
        performHomeRequest(with: homeUrl) { (result, error) in
            guard let result = result else {
                completion(nil, error)
                return
            }
            
            completion(result, nil)
            
        }
    }
    
    private func performHomeRequest(with endpoint: String, completion: @escaping (String?, AwakensError?) -> Void) {
        
        guard let homeURL = URL(string: endpoint) else {
            completion(nil, .invalidData)
            return
        }
        
       let request = URLRequest(url: homeURL)
        
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
   
    
    
        
        
    
    /*
    
    func lookupAlbum(withId id: Int, completion: @escaping (Album?, ItunesError?) -> Void) {
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.song)
        
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            guard let albumInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain album info"))
                return
            }
            
            
            guard let album = Album(json: albumInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse album information"))
                return
            }
            
            let songResults = results[1..<results.count]
            let songs = songResults.flatMap { Song(json: $0) }
            
            album.songs = songs
            completion(album, nil)
            
        }
    }
    
    
    
    
    typealias Results = [[String: Any]]
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, ItunesError?) -> Void) {
        
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
        
    }*/
    
}
