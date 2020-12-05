//
//  RockCollectionViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/14/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to track a mined rock
class RockCollectionViewCell: UICollectionViewCell {
    
    weak var databaseController: DatabaseProtocol?
    var rockObject: Rock?
    
    @IBOutlet weak var rock: UIButton!
    
    @IBAction func rockCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            rockObject?.mined = false
        } else {
            sender.isSelected = true
            rockObject?.mined = true
        }
    }
}
