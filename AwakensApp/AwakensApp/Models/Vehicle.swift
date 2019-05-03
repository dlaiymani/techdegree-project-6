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

