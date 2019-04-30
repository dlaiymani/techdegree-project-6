//
//  PeopleController.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class PeopleController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var peopleListPickerView: UIPickerView!
    
    
    let client = AwakensAPIClient()
    var data = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peopleListPickerView.delegate = self
        peopleListPickerView.dataSource = self
        client.searchForCharacters { [weak self] peoples, error in
            self?.data = peoples
            self?.peopleListPickerView.reloadAllComponents()
        }
    
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        client.lookupCharcater(withId: row) { (people, error) in
            print(people?.birthYear)
        }
    }

    

}
