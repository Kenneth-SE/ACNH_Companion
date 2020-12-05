//
//  CollectableTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class CollectableTableViewCell: UITableViewCell {
    
    enum Critter {
        case bug
        case fish
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var critterImage: UIImageView!
    @IBOutlet weak var discoveredCheckBox: UIButton!
    @IBOutlet weak var donatedCheckBox: UIButton!
    
    var fish: Fish?
    var bug: Bug?
    var critter: Critter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func discoveredButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            // Update critter properties
            if critter == .bug {
                bug?.discovered = false
            } else {
                fish?.discovered = false
            }
            
        } else {
            sender.isSelected = true
            
            // Update critter properties
            if critter == .bug {
                bug?.discovered = true
            } else {
                fish?.discovered = true
            }
            
        }
    }
    
    @IBAction func donatedButton(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            // Update critter properties
            if critter == .bug {
                bug?.donated = false
            } else {
                fish?.donated = false
            }
            
        } else {
            sender.isSelected = true
            
            // Update critter properties
            if critter == .bug {
                bug?.donated = true
            } else {
                fish?.donated = true
            }
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
