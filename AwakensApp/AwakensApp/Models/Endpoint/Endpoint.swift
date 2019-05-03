//
//  Endpoint.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

// An http endpoint protocol as view in the iTunes course
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


// An Awaken endpoint with the swapi API with two kind of request: search and lookup
extension Awakens: Endpoint {
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .search(let entity, _):
            return "/api/\(entity.rawValue)/".addingpercentEncoding()
        case .lookup(let entity, let id):
            return "/api/\(entity.rawValue)/\(id)"
        }
    }
    
   var queryItems: [URLQueryItem] {
        switch self {
        case .search(_, let page):
            var result = [URLQueryItem]()
            
            let searchItem = URLQueryItem(name: "page", value: String(page))
            result.append(searchItem)
            return result
        case .lookup(_, _):
            return []
            
        }
    }
}


extension String {
    func addingpercentEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
    }
}
