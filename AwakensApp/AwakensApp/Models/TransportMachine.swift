//
//  TransportMachine.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

class TransportMachine {
    let name: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let crew: String
    
    init(name: String, manufacturer: String, costInCredits: String, length: String, crew: String) {
        self.name = name
        self.manufacturer = manufacturer
        self.costInCredits = costInCredits
        self.length = length
        self.crew = crew
    }
    
}

