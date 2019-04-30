//
//  SearchPeopleDataSource.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit


class SearchPeopleDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    private var data = [People]()
    var selectedPeople: Int=0
    
    override init() {
        super.init()
    }
    
    func update(with peoples: [People]) {
        data = peoples
    }
    
    func getSelectedPeople() -> Int {
        return selectedPeople
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
   
    
    
}
