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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bornYearLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var unitConverter: UISegmentedControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let client = AwakensAPIClient()
    var data = [People]()
    var currentPeople: People?
    
    var metricUnit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peopleListPickerView.delegate = self
        peopleListPickerView.dataSource = self
        unitConverter.selectedSegmentIndex = 1
        activityIndicator.startAnimating()
        client.searchForCharacters { [weak self] peoples, nb, error in
            self?.data.append(contentsOf: peoples)
            if (self?.data.count)! >= nb! { // all data are downloaded
                self?.data.sort(by: { $0.name < $1.name })
                self?.peopleListPickerView.reloadAllComponents()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                let smallest = self?.data.min(by: { $0.height < $1.height })
                let largest = self?.data.max(by: { $0.height < $1.height })
                self?.smallestLabel.text = smallest?.name
                self?.largestLabel.text = largest?.name
                self?.pickerView(self!.peopleListPickerView, didSelectRow: 0, inComponent: 0)
            }
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
        self.currentPeople = self.data[row]
        if let people = self.currentPeople {
            self.titleLabel.text = people.name
            self.bornYearLabel.text = people.birthYear
            self.eyeColorLabel.text = people.eyeColor
            if people.hairColor == "n/a" {
                self.hairColorLabel.text = "Non available"
            } else {
                self.hairColorLabel.text = people.hairColor
            }
            self.displayHeight(height: people.height)
            client.lookupHome(withId: people.homeUrl) { (home, error) in
                self.homeLabel.text = home
            }
        }
    }
    
    
    @IBAction func unitChanged(_ sender: Any) {
        metricUnit = !metricUnit
        if let people = currentPeople {
            displayHeight(height: people.height)
        }
    }
    
    func displayHeight(height: String) {
        if metricUnit {
            self.heightLabel.text = "\(height)m"
        } else {
            let heightInFeet = Double(height)!*0.0328084
            let formattedHeight = String(format: "%.2f", heightInFeet)
            self.heightLabel.text = "\(formattedHeight)ft"
        }
    }
}
