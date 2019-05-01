//
//  TransportMachine.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class TransportMachine: AwakenData  {
    var name: String
    var measure: String
    let manufacturer: String
    let costInCredits: String
    let crew: String
    
    init(name: String, manufacturer: String, costInCredits: String, length: String, crew: String) {
        self.name = name
        self.manufacturer = manufacturer
        self.costInCredits = costInCredits
        self.measure = length
        self.crew = crew
    }
    
}

