//
//  VillagerTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to show a villager and their status to the user
class VillagerTableViewCell: UITableViewCell {

    @IBOutlet weak var villagerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentResidentCheckBox: UIButton!
    @IBOutlet weak var favouriteCheckBox: UIButton!
    
    var villager: Villager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Status checkboxes
    
    @IBAction func ownedCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            villager?.currentResident = false
        } else {
            sender.isSelected = true
            villager?.currentResident = true
        }
    }
    
    @IBAction func wishlistCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            villager?.favourite = false
        } else {
            sender.isSelected = true
            villager?.favourite = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
