//
//  Vehicle.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class Vehicle: TransportMachine {
    
    let vehicleClass: String
    
    
    init(name: String, manufacturer: String, costInCredits: String, length: String, vehicleClass: String, crew: String) {
        self.vehicleClass = vehicleClass
        super.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, crew: crew)
    }
    
    convenience init?(json: [String: Any]) {
        struct Key {
            static let name = "name"
            static let manufacturer = "manufacturer"
            static let costInCredits = "cost_in_credits"
            static let length = "length"
            static let vehicleClass = "vehicle_class"
            static let crew = "crew"
        }
        guard let name = json[Key.name] as? String,
            let manufacturer = json[Key.manufacturer] as? String,
            let costInCredits = json[Key.costInCredits] as? String,
            let length = json[Key.length] as? String,
            let vehicleClass = json[Key.vehicleClass] as? String,
            let crew = json[Key.crew] as? String else { return nil }
        
        self.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, vehicleClass: vehicleClass, crew: crew)
        
    }
}


    






//
//
//"cargo_capacity": "50000",
//"consumables": "2 months",
//"cost_in_credits": "150000",
//"created": "2014-12-10T15:36:25.724000Z",
//"crew": "46",
//"edited": "2014-12-10T15:36:25.724000Z",
//"length": "36.8",
//"manufacturer": "Corellia Mining Corporation",
//"max_atmosphering_speed": "30",
//"model": "Digger Crawler",
//"name": "Sand Crawler",
//"passengers": "30",
//"pilots": [],
//"vehicle_class": "wheeled"
