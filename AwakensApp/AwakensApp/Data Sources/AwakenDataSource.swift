//
//  AwakenDataSource.swift
//  AwakensApp
//
//  Created by davidlaiymani on 02/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit


class AwakenDataSource: NSObject, UIPickerViewDataSource {
    
    private var data = [AwakenData]()

    let pickerView: UIPickerView
    
    init(data: [AwakenData], pickerView: UIPickerView) {
        self.data = data
        self.pickerView = pickerView
        super.init()
    }
    

    // MARK: - Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }
    
    // MARK: - Helper methods
    
    func awakenData(at index: Int) -> AwakenData {
        return data[index]
    }
    
    func update(with data: [AwakenData]) {
        self.data.append(contentsOf: data)
        self.data.sort(by: { $0.name < $1.name })
    }
    
    func numberOfElements() -> Int {
        return data.count
    }
    
    func smallestElement() -> AwakenData? {
        return data.min(by: { $0.measure < $1.measure })
    }
    
    func greatestElement() -> AwakenData? {
        return data.max(by: { $0.measure < $1.measure })
    }
    
}
