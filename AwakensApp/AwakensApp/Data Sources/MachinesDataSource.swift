//
//  MachinesDataSource.swift
//  AwakensApp
//
//  Created by davidlaiymani on 02/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import Foundation
import UIKit

class MachinesDataSource: NSObject, UITableViewDataSource {
    private var machinesNames: [String]
    
    init(machinesNames: [String]) {
        self.machinesNames = machinesNames
    }
    
    
    // MARK: - Data Sources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machinesNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let machineCell = tableView.dequeueReusableCell(withIdentifier: "MachineCell", for: indexPath)
        
        let machine = machinesNames[indexPath.row]
        machineCell.textLabel?.text = machine
        
        return machineCell
    }
    
    // MARK: - Helper Methods
    
    func update(with machinesNames: [String]) {
        self.machinesNames.append(contentsOf: machinesNames)
        self.machinesNames.sort(by: { $0 < $1 })
    }
}
