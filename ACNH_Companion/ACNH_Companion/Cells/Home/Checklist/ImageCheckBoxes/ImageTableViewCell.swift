//
//  ImageTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/14/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used for showing the collection views of checklist images (villagers and rocks)
class ImageTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Villager collection view
            let cell = tableView.dequeueReusableCell(withIdentifier: "villagerCheckBoxCell") as! VillagerCheckBoxTableViewCell
            cell.updateCurrentResidents()
            
            if cell.villagers.count == 0 {
                let basicCell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
                basicCell?.textLabel?.text = "No current residents yet!"
                
                return basicCell!
            }
            
            return cell
        }
        // Rock collection view
        let cell = tableView.dequeueReusableCell(withIdentifier: "rockCheckBoxCell") as! RockCheckBoxTableViewCell
        cell.updateCurrentRocks()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Talk to villagers"
        }
        return "Mine rocks"
    }

}
