//
//  CritterDetailsTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/20/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the details of a specific critter
class CritterDetailsTableViewController: UITableViewController {
    
    enum Critter {
        case bug
        case fish
    }
    
    let CELL_CRITTER_DETAILS = "critterDetailsCell"
    
    var name: String?
    var nameUSen: String?
    var sell: String?
    var location: String?
    var rarity: String?
    var time: String?
    var shadow: String?
    var critter: Critter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 400.0
        
        title = name!
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // MARK: - SHOULD BE 2 one more for availability
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_CRITTER_DETAILS, for: indexPath)  as! CritterDetailsTableViewCell

        // Configure the cell...
        cell.critterImage.image = UIImage(named: nameUSen! + "Image")
        cell.sellLabel.text = sell ?? "Unknown"
        cell.locationLabel.text = location ?? "Unknown"
        cell.rarityLabel.text = rarity ?? "Unknown"
        cell.timeLabel.text = time ?? "Unknown"
        
        if critter == .bug {
            cell.shadowTitle.text = ""
            cell.shadowLabel.text = ""
        } else {
            cell.shadowLabel.text = shadow
        }

        return cell
    }
}
