//
//  PeopleController.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class AwakenController: UITableViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var dataListPickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    @IBOutlet weak var cellVehiculeLabel: UILabel!
    @IBOutlet weak var cellStarshipLabel: UILabel!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    @IBOutlet weak var unitConverter: UISegmentedControl!
    @IBOutlet weak var currencyConverter: UISegmentedControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var descriptionLabels: [UILabel]!
    
    let descriptionLabelsForPeople = ["Born", "Home", "Height", "Eyes", "Hairs"]
    let descriptionLabelsForVehicle = ["Make", "Cost", "Length", "Class", "Crew"]
    
    let client = AwakensAPIClient()
    
    var currentPeople: People?
    var currentMachine: TransportMachine?
    var endpoint: Endpoint?
    var entity: Entity?
    
    lazy var dataSource: AwakenDataSource = {
        return AwakenDataSource(data: [], pickerView: self.dataListPickerView)
    }()
    
    var metricUnit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDecriptionLabels()
        configureConverters()
        configureTitles()
        dataListPickerView.delegate = self
        dataListPickerView.dataSource = dataSource
        
        activityIndicator.startAnimating()
        
        client.searchForData(with : endpoint!, forEntity: entity!) { [weak self] data, nb, error in
            
            if let error = error {
                self?.displayAlert(forError: error)
            } else {
                self?.createDataArray(with: data, forSize: nb!)
            }
            
        }
    }

    
    // MARK: - Configure the view
    
    func configureDecriptionLabels() {
        guard let entity = entity else { return }
        
        for (index, _) in descriptionLabels.enumerated() {
            if entity == .people {
                self.descriptionLabels[index].text = descriptionLabelsForPeople[index]
            } else {
                descriptionLabels[index].text = descriptionLabelsForVehicle[index]
            }
        }

    }
    
    func configureConverters() {
        
        guard let entity = entity else { return }

        unitConverter.selectedSegmentIndex = 1
        currencyConverter.selectedSegmentIndex = 1
        if entity == .people {
            currencyConverter.isHidden = true
            currencyConverter.isEnabled = false
        } else {
            currencyConverter.isHidden = false
            currencyConverter.isEnabled = true
        }
    }
    
    func configureTitles() {
        guard let entity = entity else { return }
        switch entity {
        case .people:
            titleLabel.text = "Characters"
        case .vehicles:
            titleLabel.text = "Vehicles"
        case .starships:
            titleLabel.text = "Starships"
        }
    }
    
    func configure(with viewModel: PeopleViewModel) {
        
       
        self.titleLabel.text = viewModel.name
        self.firstLabel.text = viewModel.birthYear
        self.fourthLabel.text = viewModel.eyeColor
        self.fifthLabel.text = viewModel.hairColor
        self.displayMeasure(measure: viewModel.height)
        self.secondLabel.text = "Loading..."
        
        

        client.lookupData(withId: viewModel.home) { (home, error) in
            
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
    
    
    
    func createDataArray(with awakenData: [AwakenData], forSize size: Int) {
        dataSource.update(with: awakenData)
        if dataSource.numberOfElements() >= size { // all the data are downloaded
            self.dataListPickerView.reloadAllComponents()
            self.activityIndicator.stopAnimating()
            self.tableView.cellForRow(at: IndexPath(row: 0, section: 2))?.isUserInteractionEnabled = true
            self.tableView.cellForRow(at: IndexPath(row: 1, section: 2))?.isUserInteractionEnabled = true
            self.activityIndicator.isHidden = true
            self.smallestLabel.text = dataSource.smallestElement()?.name
            self.largestLabel.text = dataSource.greatestElement()?.name
            self.pickerView(self.dataListPickerView, didSelectRow: 0, inComponent: 0)
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if entity! == .people { // Not proud of this
            return 3
        } else {
            return 2
        }
    }


    // MARK: - PickerView Delegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource.awakenData(at: row).name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let entity = entity else { return }

        switch entity {
        case .people:
            self.currentPeople = self.dataSource.awakenData(at: row) as? People
            if let people = self.currentPeople {
                let viewModel = PeopleViewModel(people: people)
                configure(with: viewModel)
            }
        case .vehicles, .starships:
            self.currentMachine =  self.dataSource.awakenData(at: row) as? TransportMachine
            if let machine = self.currentMachine {
                let viewModel = TransportMachineViewModel(machine: machine)
                configure(with: viewModel)
            }
        }
    }
    
    
    
    // MARK: - Configure the converters
    
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
    
    
    @IBAction func currencyConverterTapped(_ sender: UISegmentedControl) {
        
        guard let currentMachine = currentMachine, let costInCredits = Double(currentMachine.costInCredits) else {
            currencyConverter.selectedSegmentIndex = 1
            return
        }
        
        var conversionRate = 1.0
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
            self.secondLabel.text = "\(costInCredits)"
        }
    }
    
    
    // MARK - AlertView helper methods
    
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let people = currentPeople else { return }
        let machinesController = segue.destination as! MachinesController
        
        switch segue.identifier {
        case "showVehicles":
            let numberOfVehicles = people.vehicles.count
            if numberOfVehicles > 0 {
                machinesController.peopleName = "\(people.name)'s Vehicules"
                for i in 0...numberOfVehicles-1 {
                    client.lookupData(withId: people.vehicles[i]) { (vehiculeName, error) in
                        machinesController.machinesNames = [vehiculeName!]
                    }
                }
            } else {
                machinesController.peopleName = "No Vehicules"
            }
        case "showStarships":
                let numberOfStarships = people.starships.count
                if numberOfStarships > 0 {
                    machinesController.peopleName = "\(people.name)'s Starships"
                    for i in 0...numberOfStarships-1 {
                        client.lookupData(withId: people.starships[i]) { (vehiculeName, error) in
                            machinesController.machinesNames = [vehiculeName!]
                        }
                    }
                } else {
                    machinesController.peopleName = "No Starships"
                }
        default:
            break
        }
    }
    
}
