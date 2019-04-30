//
//  Endpoint.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
   // var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
       // components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}


enum Entity: String {
    case people = "people"
    case vehicles = "vehicles"
    case starships = "starships"
}

enum Awakens {
    case search(entity: Entity)
    case lookup(entity: Entity, id: Int)
}


extension Awakens: Endpoint {
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        
        switch self {
        case .search(let entity):
            return "/api/\(entity.rawValue)"
        case .lookup(let entity, let id):
            return "/api/\(entity.rawValue)/\(id)"
        }
    }
    
   /* var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let media):
            var result = [URLQueryItem]()
            
            let searchItem = URLQueryItem(name: "term", value: term)
            result.append(searchItem)
            
            if let media = media {
                let mediaItem = URLQueryItem(name: "media", value: media.description)
                result.append(mediaItem)
                
                if let entityQueryItem = media.entityQueryItem {
                    result.append(entityQueryItem)
                }
                
                if let attributeQueryItem = media.attributeQueryItem {
                    result.append(attributeQueryItem)
                }
            }
            return result
        case .lookup(let id, let entity):
            return [
                URLQueryItem(name: "id", value: id.description),
                URLQueryItem(name: "entity", value: entity?.entityName)
            ]
            
        }
    }*/
}
