//
//  MachinesController.swift
//  AwakensApp
//
//  Created by davidlaiymani on 02/05/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class MachinesController: UITableViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var peopleName: String?
    
    var machinesNames: [String]? {
        didSet {
            if let machinesNames = machinesNames {
                dataSource.update(with: machinesNames)
                tableView.reloadData()
            }
        }
    }
    
    var dataSource = MachinesDataSource(machinesNames: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = peopleName

        tableView.dataSource = dataSource
    }

    
}
