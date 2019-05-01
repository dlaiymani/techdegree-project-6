//
//  PeopleController.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class AwakenController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dataListPickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bornYearLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var unitConverter: UISegmentedControl!
    @IBOutlet weak var currencyConverter: UISegmentedControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var descriptionLabels: [UILabel]!
    
    let descriptionLabelsForPeople = ["Born", "Home", "Height", "Eyes", "Hairs"]
    let descriptionLabelsForVehicle = ["Make", "Cost", "Length", "Class", "Crew"]
    
    let client = AwakensAPIClient()
    
    var data = [AwakenData]()
    var currentPeople: People?
    var currentMachine: TransportMachine?
    var endpoint: Endpoint?
    var entity: Entity?
    
    var metricUnit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDecriptionLabels(forEntity: entity!)
        dataListPickerView.delegate = self
        dataListPickerView.dataSource = self
        
        unitConverter.selectedSegmentIndex = 1
        currencyConverter.selectedSegmentIndex = 1
        if let entity = entity {
            if entity == .people {
                currencyConverter.isHidden = true
            } else {
                currencyConverter.isHidden = false
            }
        }
        activityIndicator.startAnimating()
        
        client.searchForData(with : endpoint!, forEntity: entity!) { [weak self] data, nb, error in
            
            self?.createDataArray(with: data, forSize: nb!)
        }
        
    }
    
    
    func configureDecriptionLabels(forEntity entity: Entity) {
        for (index, _) in descriptionLabels.enumerated() {
            if entity == .people {
                self.descriptionLabels[index].text = descriptionLabelsForPeople[index]
            } else {
                descriptionLabels[index].text = descriptionLabelsForVehicle[index]

            }
        }
    }
    

    
    func createDataArray(with awakenData: [AwakenData], forSize size: Int) {
        self.data.append(contentsOf: awakenData)
        //self?.peopleData.append(contentsOf: peoples)
        if (self.data.count) >= size { // all data are downloaded
            self.data.sort(by: { $0.name < $1.name })
            self.dataListPickerView.reloadAllComponents()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            let smallest = self.data.min(by: { $0.measure < $1.measure })
            let largest = self.data.max(by: { $0.measure < $1.measure })
            self.smallestLabel.text = smallest?.name
            self.largestLabel.text = largest?.name
            self.pickerView(self.dataListPickerView, didSelectRow: 0, inComponent: 0)
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
        if let entity = entity {
            switch entity {
            case .people:
                self.currentPeople = self.data[row] as? People
                if let people = self.currentPeople {
                    let viewModel = PeopleViewModel(people: people)
                    configure(with: viewModel)
                }
            case .vehicles, .starships:
                self.currentMachine = self.data[row] as? TransportMachine
                if let machine = self.currentMachine {
                    let viewModel = TransportMachineViewModel(machine: machine)
                    configure(with: viewModel)
                }
            }
        }
    }
    
    
    func configure(with viewModel: PeopleViewModel) {
        self.titleLabel.text = viewModel.name
        self.bornYearLabel.text = viewModel.birthYear
        self.eyeColorLabel.text = viewModel.eyeColor
        self.hairColorLabel.text = viewModel.hairColor
        self.displayMeasure(measure: viewModel.height)
        client.lookupHome(withId: viewModel.home) { (home, error) in
            self.homeLabel.text = home
        }
    }
    
    func configure(with viewModel: TransportMachineViewModel) {
        self.titleLabel.text = viewModel.name
        self.bornYearLabel.text = viewModel.manufacturer
        self.eyeColorLabel.text = viewModel.cost
        self.hairColorLabel.text = viewModel.crew
        self.homeLabel.text = viewModel.crew
        self.displayMeasure(measure: viewModel.length)
    }
    
    
    @IBAction func unitChanged(_ sender: Any) {
        metricUnit = !metricUnit
        if let people = currentPeople {
            displayMeasure(measure: people.measure)
        }
        if let vehicle = currentMachine {
            displayMeasure(measure: vehicle.measure)
        }
    }
    
    func displayMeasure(measure: String) {
        
        if let sizeInCm = Double(measure) {
            if metricUnit {
                if entity == .people {
                    self.heightLabel.text = "\(measure)cm"
                } else {
                    self.heightLabel.text = "\(measure)m"
                }
            } else {
                var heightInFeet = 0.0
                if entity != .people {
                    heightInFeet = sizeInCm*3.28084

                } else {
                    heightInFeet = sizeInCm*0.0328084
                }

                let formattedHeight = String(format: "%.2f", heightInFeet)
                self.heightLabel.text = "\(formattedHeight)ft"
            }
        }
    }
}
