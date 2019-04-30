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
    
    func searchForCharacters(completion: @escaping ([People], AwakensError?) -> Void) {
        
        let endpoint = Awakens.search(entity: .people)
        performRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion([], error)
                return
            }
            
            let peoples = results.flatMap({ People(json: $0) })
            completion(peoples, nil)
        }
    }
    
    
    func lookupCharcater(withId id: Int, completion: @escaping (People?, AwakensError?) -> Void) {
        let endpoint = Awakens.lookup(entity: .people, id: id)
        print(endpoint.request)
        
        performSimpleRequest(with: endpoint) { (results, error) in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            guard let people = People(json: results) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse people information"))
                return
            }
            
            completion(people, nil)
            
        }
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
    
    
    private func performSimpleRequest(with endpoint: Endpoint, completion: @escaping ([String: Any]?, AwakensError?) -> Void) {
        
        let task = downloader.jsonTask(with: endpoint.request) { (json, error) in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                completion(json, nil)
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
