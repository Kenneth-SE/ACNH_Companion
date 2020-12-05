//
//  VillagerCollectionViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/15/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to track a villager task
class VillagerCollectionViewCell: UICollectionViewCell {
    
    weak var databaseController: DatabaseProtocol?
    var villagerObject: Villager?
    
    @IBOutlet weak var villager: UIButton!
    
    @IBAction func villagerCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            villagerObject?.talkedTo = false
        } else {
            sender.isSelected = true
            villagerObject?.talkedTo = true
        }
        
        // Save context
        databaseController?.saveContext()
    }
}
