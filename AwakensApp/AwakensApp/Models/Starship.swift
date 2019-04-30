//
//  Starship.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class Starship:TransportMachine {
    let starshipClass: String
    
    
    init(name: String, manufacturer: String, costInCredits: String, length: String, starshipClass: String, crew: String) {
        self.starshipClass = starshipClass
        super.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, crew: crew)
    }
    
    convenience init?(json: [String: Any]) {
        struct Key {
            static let name = "name"
            static let manufacturer = "manufacturer"
            static let costInCredits = "cost_in_credits"
            static let length = "length"
            static let starshipClass = "starship_class"
            static let crew = "crew"
        }
        guard let name = json[Key.name] as? String,
            let manufacturer = json[Key.manufacturer] as? String,
            let costInCredits = json[Key.costInCredits] as? String,
            let length = json[Key.length] as? String,
            let starshipClass = json[Key.starshipClass] as? String,
            let crew = json[Key.crew] as? String else { return nil }
        
        self.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, starshipClass: starshipClass, crew: crew)
        
    }
}

//"MGLT": "10 MGLT",
//"cargo_capacity": "1000000000000",
//"consumables": "3 years",
//"cost_in_credits": "1000000000000",
//"created": "2014-12-10T16:36:50.509000Z",
//"crew": "342953",
//"edited": "2014-12-10T16:36:50.509000Z",
//"hyperdrive_rating": "4.0",
//"length": "120000",
//"manufacturer": "Imperial Department of Military Research, Sienar Fleet Systems",
//"max_atmosphering_speed": "n/a",
//"model": "DS-1 Orbital Battle Station",
//"name": "Death Star",
//"passengers": "843342",
//"films": [
//"https://swapi.co/api/films/1/"
//],
//"pilots": [],
//"starship_class": "Deep Space Mobile Battlestation",
//"url": "https://swapi.co/api/starships/9/"
