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
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
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
    case search(entity: Entity, page: Int)
    case lookup(entity: Entity, id: Int)
}


extension Awakens: Endpoint {
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        
        switch self {
        case .search(let entity, let page):
            return "/api/\(entity.rawValue)/".addingpercentEncoding()
        case .lookup(let entity, let id):
            return "/api/\(entity.rawValue)/\(id)"
        }
    }
    
   var queryItems: [URLQueryItem] {
        switch self {
        case .search(let entity, let page):
            var result = [URLQueryItem]()
            
            let searchItem = URLQueryItem(name: "page", value: String(page))
            result.append(searchItem)
            return result
        case .lookup(let id, let entity):
            return []
            
        }
    }
}


extension String {
    func addingpercentEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
    }
}
