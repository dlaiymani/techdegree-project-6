//
//  VehicleViewModel.swift
//  AwakensApp
//
//  Created by davidlaiymani on 01/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

struct TransportMachineViewModel {
    let name: String
    let manufacturer: String
    let cost: String
    let length: String
    let vehicleClass: String
    let crew: String
}


extension TransportMachineViewModel {
    init(machine: TransportMachine) {
        self.name = machine.name
        self.manufacturer = machine.manufacturer
        self.cost = machine.costInCredits
        self.length = machine.measure
        if let vehicle = machine as? Vehicle {
            self.vehicleClass = vehicle.vehicleClass
        } else {
            if let starship = machine as? Starship {
                self.vehicleClass = starship.starshipClass
            } else {
                self.vehicleClass = ""
            }
        }
        self.crew = machine.crew
        
    }
}
