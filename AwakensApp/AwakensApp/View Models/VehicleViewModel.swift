//
//  VehicleViewModel.swift
//  AwakensApp
//
//  Created by davidlaiymani on 01/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

struct VehicleViewModel {
    let name: String
    let manufacturer: String
    let cost: String
    let length: String
    let vehicleClass: String
    let crew: String
}


extension VehicleViewModel {
    init(vehicle: Vehicle) {
        self.name = vehicle.name
        self.manufacturer = vehicle.manufacturer
        self.cost = vehicle.costInCredits
        self.length = vehicle.measure
        self.vehicleClass = vehicle.vehicleClass
        self.crew = vehicle.crew
        
    }
}
