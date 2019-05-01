//
//  People.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class People {
    let name: String
    let birthYear: String
    let homeUrl: String
    let height: String
    let eyeColor: String
    let hairColor: String
    
    init(name: String, birthYear: String, homeUrl: String, height: String, eyeColor: String, hairColor: String) {
        self.name = name
        self.birthYear = birthYear
        self.homeUrl = homeUrl
        self.height = height
        self.eyeColor = eyeColor
        self.hairColor = hairColor
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
        }
        
        guard let name = json[Key.name] as? String,
            let birthYear = json[Key.birthYear] as? String,
            let homeUrl = json[Key.homeUrl] as? String,
            let height = json[Key.height] as? String,
            let eyeColor = json[Key.eyeColor] as? String,
            let hairColor = json[Key.hairColor] as? String else { return nil }
        
        self.init(name: name, birthYear: birthYear, homeUrl: homeUrl, height: height, eyeColor: eyeColor, hairColor: hairColor)
        
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



//"name": "Luke Skywalker",
//"height": "172",
//"mass": "77",
//"hair_color": "blond",
//"skin_color": "fair",
//"eye_color": "blue",
//"birth_year": "19BBY",
//"gender": "male",
//"homeworld": "https://swapi.co/api/planets/1/",
