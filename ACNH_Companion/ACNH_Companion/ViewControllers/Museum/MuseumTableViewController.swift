//
//  MuseumTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the categories for each collectable in the museum
class MuseumTableViewController: UITableViewController {
    
    let CELL_CATEGORY = "categoryCell"
    let SECTION_BUGS = 0
    let SECTION_FISH = 1
    
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 186.0
        
        createDefaultCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    // Amount of categories in the museum
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    // Each category is one cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: CELL_CATEGORY, for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.section]

        // Configure the cell
        categoryCell.categoryImage.image = category.image
        categoryCell.categoryLabel.text = category.label

        return categoryCell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "critterTableSegue") {
            let destination = segue.destination as! CritterTableViewController
            
            // Set the details page to selected critter
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == SECTION_BUGS {
                    destination.title = "Bugs"
                    destination.listenerType = .bugs
                } else if indexPath.section == SECTION_FISH {
                    destination.title = "Fish"
                    destination.listenerType = .fish
                }
                destination.availablilityFilter = false
            }
        }
    }
    
    // MARK: - Create Defaults

    func createDefaultCategories() {
        let c1 = Category()
        let c2 = Category()
        
        c1.label = "Bugs"
        c1.image = #imageLiteral(resourceName: "InsectMonkichoCropped")
        c2.label = "Fish"
        c2.image = #imageLiteral(resourceName: "FishSuzukiCropped")
        
        categories.append(c1)
        categories.append(c2)
    }

}
