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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let client = AwakensAPIClient()
    var peopleData = [People]()
    var vehicleData = [Vehicle]()
    var starshipData = [Starship]()
    var transportMachineDate = [TransportMachine]()
    var data = [AwakenData]()
    var currentPeople: People?
    var currentVehicle: Vehicle?
    var endpoint: Endpoint?
    var entity: Entity?
    
    var metricUnit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataListPickerView.delegate = self
        dataListPickerView.dataSource = self
        
        unitConverter.selectedSegmentIndex = 1
        activityIndicator.startAnimating()
        
        if let entity = entity {
            downloadData(for: entity)
        }
        
        
      /*  client.searchForCharacters { [weak self] peoples, nb, error in
            self?.peopleData.append(contentsOf: peoples)
            if (self?.peopleData.count)! >= nb! { // all data are downloaded
                self?.peopleData.sort(by: { $0.name < $1.name })
                self?.dataListPickerView.reloadAllComponents()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                let smallest = self?.peopleData.min(by: { $0.height < $1.height })
                let largest = self?.peopleData.max(by: { $0.height < $1.height })
                self?.smallestLabel.text = smallest?.name
                self?.largestLabel.text = largest?.name
                self?.pickerView(self!.dataListPickerView, didSelectRow: 0, inComponent: 0)
            }
        }*/
    
    }
    
    func downloadData(for entity: Entity) {
        switch entity {
        case .people:
            searchForPeople()
            print(endpoint!.request)
        case .vehicles:
            searchForVehicle()
            print(endpoint!.request)

        case .starships:
            //searchForData(in: starshipData)
            print(endpoint!.request)
        default:
            break
        }
    }
    
    
    func searchForPeople() {
        client.searchForCharacters(with : endpoint!) { [weak self] peoples, nb, error in
            
            self?.createDataArray(with: peoples, forSize: nb!)
            
//            self?.data.append(contentsOf: peoples)
//            //self?.peopleData.append(contentsOf: peoples)
//            if (self?.data.count)! >= nb! { // all data are downloaded
//                self?.data.sort(by: { $0.name < $1.name })
//                self?.dataListPickerView.reloadAllComponents()
//                self?.activityIndicator.stopAnimating()
//                self?.activityIndicator.isHidden = true
//             //   let smallest = self?.data.min(by: { $0.height < $1.height })
//             //   let largest = self?.data.max(by: { $0.height < $1.height })
//               // self?.smallestLabel.text = smallest?.name
//             //   self?.largestLabel.text = largest?.name
//                self?.pickerView(self!.dataListPickerView, didSelectRow: 0, inComponent: 0)
//            }
        }
    }
    
    func searchForVehicle() {
        client.searchForVehicles(with : endpoint!) { [weak self] vehicles, nb, error in
            
            self?.createDataArray(with: vehicles, forSize: nb!)

           /* self?.vehicleData.append(contentsOf: vehicles)
            if (self?.vehicleData.count)! >= nb! { // all data are downloaded
                self?.vehicleData.sort(by: { $0.name < $1.name })
                self?.dataListPickerView.reloadAllComponents()
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
                let smallest = self?.vehicleData.min(by: { $0.length < $1.length })
                let largest = self?.vehicleData.max(by: { $0.length < $1.length })
                self?.smallestLabel.text = smallest?.name
                self?.largestLabel.text = largest?.name
                self?.pickerView(self!.dataListPickerView, didSelectRow: 0, inComponent: 0)
            }*/
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
        switch entity! {
        case .people:
            self.currentPeople = self.data[row] as? People
            if let people = self.currentPeople {
                let viewModel = PeopleViewModel(people: people)
                configure(with: viewModel)
                
            }
        case .vehicles:
            self.currentVehicle = self.data[row] as? Vehicle
            if let vehicle = self.currentVehicle {
                let viewModel = VehicleViewModel(vehicle: vehicle)
                configure(with: viewModel)
            }
        case .starships:
            break
        }
        
    }
    
    
    func configure(with viewModel: PeopleViewModel) {
        self.titleLabel.text = viewModel.name
        self.bornYearLabel.text = viewModel.birthYear
        self.eyeColorLabel.text = viewModel.eyeColor
        self.hairColorLabel.text = viewModel.hairColor
        self.displayHeight(height: viewModel.height)
        client.lookupHome(withId: viewModel.home) { (home, error) in
            self.homeLabel.text = home
        }
    }
    
    func configure(with viewModel: VehicleViewModel) {
        self.titleLabel.text = viewModel.name
        self.bornYearLabel.text = viewModel.manufacturer
        self.eyeColorLabel.text = viewModel.cost
        self.hairColorLabel.text = viewModel.crew
        self.homeLabel.text = viewModel.crew
        self.displayHeight(height: viewModel.length)
    }
    
    
    @IBAction func unitChanged(_ sender: Any) {
        metricUnit = !metricUnit
        if let people = currentPeople {
            displayHeight(height: people.measure)
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
