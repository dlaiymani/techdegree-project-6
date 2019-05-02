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
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
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
                currencyConverter.isEnabled = false
            } else {
                currencyConverter.isHidden = false
                currencyConverter.isEnabled = true
            }
        }
        activityIndicator.startAnimating()
        
        client.searchForData(with : endpoint!, forEntity: entity!) { [weak self] data, nb, error in
            
            if let error = error {
                self?.displayAlert(forError: error)
            } else {
                self?.createDataArray(with: data, forSize: nb!)
            }
            
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
        self.firstLabel.text = viewModel.birthYear
        self.fourthLabel.text = viewModel.eyeColor
        self.fifthLabel.text = viewModel.hairColor
        self.displayMeasure(measure: viewModel.height)
        self.secondLabel.text = "Loading..."
        client.lookupHome(withId: viewModel.home) { (home, error) in
            
            if let error = error {
                self.secondLabel.text = "??"
                self.displayAlert(forError: error)
            } else {
                self.secondLabel.text = home
            }
        }
    }
    
    func configure(with viewModel: TransportMachineViewModel) {
        self.titleLabel.text = viewModel.name
        self.firstLabel.text = viewModel.manufacturer
        self.secondLabel.text = viewModel.cost
        self.fourthLabel.text = viewModel.vehicleClass
        self.fifthLabel.text = viewModel.crew
        self.displayMeasure(measure: viewModel.length)
        self.currencyConverter.selectedSegmentIndex = 1
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
                    self.thirdLabel.text = "\(measure)cm"
                } else {
                    self.thirdLabel.text = "\(measure)m"
                }
            } else {
                var heightInFeet = 0.0
                if entity != .people {
                    heightInFeet = sizeInCm*3.28084

                } else {
                    heightInFeet = sizeInCm*0.0328084
                }

                let formattedHeight = String(format: "%.2f", heightInFeet)
                self.thirdLabel.text = "\(formattedHeight)ft"
            }
        }
    }
    
    
    // rework on optionnals
    @IBAction func currencyConverterTapped(_ sender: UISegmentedControl) {
        
        var conversionRate = 1.0
        if let currentMachine = currentMachine {
            if let costInCredits = Double(currentMachine.costInCredits) {
                if currencyConverter.selectedSegmentIndex == 0 {
                    let alertController = UIAlertController(title: "Currency converter to USD", message: "Please enter an exchange rate", preferredStyle: .alert)
                    alertController.addTextField { textField in
                        textField.placeholder = "Exchange Rate"
                    }
                    let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
                        guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
                        if let rate = Double(textField.text!) {
                            conversionRate = rate
                            let usdValue = costInCredits*conversionRate
                            self.secondLabel.text = "\(usdValue)$"
                        }
                    }
                    alertController.addAction(confirmAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                } else {
                    self.secondLabel.text = "\(costInCredits) credits"
                }
            } else {
                currencyConverter.selectedSegmentIndex = 1
            }
        }
        
    }
    
    // Display an alertView with a given title and a givent message
    func alert(withTitle title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func displayAlert(forError error: AwakensError) {
        switch error {
        case .requestFailed:
            alert(withTitle: "Network connection error", andMessage: "Please check your network connection")
        case .invalidData, .jsonConversionFailure:
            alert(withTitle: "Data error", andMessage: "Data format seems incorrect")
        case .responseUnsuccessful:
            alert(withTitle: "Bad server response", andMessage: "The server's response seems incorrect")
        case .jsonParsingFailure(let message):
            alert(withTitle: "JSON error", andMessage: message)
        }
    }
    
}
