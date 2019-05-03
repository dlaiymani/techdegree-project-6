//
//  People.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

protocol AwakenData {
    var name: String { get }
    var measure: String { get }
}

class People: AwakenData {
    
    var name: String
    let birthYear: String
    let homeUrl: String
    var measure: String
    let eyeColor: String
    let hairColor: String
    let vehicles: [String]
    let starships: [String]
    
    init(name: String, birthYear: String, homeUrl: String, height: String, eyeColor: String, hairColor: String, vehicles: [String], starships: [String]) {
        self.name = name
        self.birthYear = birthYear
        self.homeUrl = homeUrl
        self.measure = height
        self.eyeColor = eyeColor
        self.hairColor = hairColor
        self.vehicles = vehicles
        self.starships = starships
    }
}


extension People {
    convenience init?(json: [String: Any]) {
        
        struct Key {
            static let name = "name"
            static let birthYear = "birth_year"
            static let homeUrl = "homeworld"
            static let height = "height"
            static let eyeColor = "eye_color"
            static let hairColor = "hair_color"
            static let vehicles = "vehicles"
            static let starships = "starships"
        }
        
        guard let name = json[Key.name] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let homeUrl = json[Key.homeUrl] as? String,
            let height = json[Key.height] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let hairColor = json[Key.hairColor] as? String,
            let vehicles = json[Key.vehicles] as? [String],
            let starships = json[Key.starships] as? [String] else { return nil }
        
        self.init(name: name, birthYear: birthYear, homeUrl: homeUrl, height: height, eyeColor: eyeColor, hairColor: hairColor, vehicles: vehicles,
                starships: starships)
        
    }
}

extension People: Comparable {
    static func == (lhs: People, rhs: People) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func <(lhs: People, rhs: People) -> Bool {
        return lhs.name < rhs.name
    }
}

