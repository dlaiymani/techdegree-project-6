//
//  ViewController.swift
//  AwakensApp
//
//  Created by davidlaiymani on 30/04/2019.
//  Copyright © 2019 davidlaiymani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let infoController = segue.destination as? AwakenController
        switch segue.identifier {
        case "characterSegue":
            infoController?.endpoint = Awakens.search(entity: .people, page: 1)
            infoController?.entity = .people
        case "vehicleSegue":
            infoController?.endpoint = Awakens.search(entity: .vehicles, page: 1)
            infoController?.entity = .vehicles
        case "starshipSegue":
            infoController?.endpoint = Awakens.search(entity: .starships, page: 1)
            infoController?.entity = .starships
        default: break
        }
    }

}

