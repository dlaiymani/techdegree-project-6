//
//  PeopleViewModel.swift
//  AwakensApp
//
//  Created by davidlaiymani on 01/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation

struct PeopleViewModel {
    let name: String
    let birthYear: String
    let height: String
    let eyeColor: String
    let hairColor: String
    let home: String
}


extension PeopleViewModel {
    init(people: People) {
        self.name = people.name
        self.birthYear = people.birthYear
        self.height = people.measure
        if people.hairColor == "n/a" {
            self.hairColor = "Non available"
        } else {
            self.hairColor = people.hairColor
        }
        self.eyeColor = people.eyeColor
        
        self.home = people.homeUrl
    }
}
