//
//  ChecklistTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/12/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// The checklist of the general everyday tasks
class ChecklistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nookStop: UIButton!
    @IBOutlet weak var recyclingBin: UIButton!
    @IBOutlet weak var shakeTrees: UIButton!
    @IBOutlet weak var moneyTrees: UIButton!
    @IBOutlet weak var items: UIButton!
    @IBOutlet weak var turnipPrices: UIButton!
    @IBOutlet weak var fossils: UIButton!
    
    weak var databaseController: DatabaseProtocol?
    var checklistObject: Checklist?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Check box functionality that can be turned on and off and be reflected in core data
    
    @IBAction func nookStopCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.nookStop = false
        } else {
            sender.isSelected = true
            checklistObject?.nookStop = true
        }
    }
    
    @IBAction func recyclingCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.recyclingBin = false
        } else {
            sender.isSelected = true
            checklistObject?.recyclingBin = true
        }
    }
    
    @IBAction func shakeTreesCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.shakeTrees = false
        } else {
            sender.isSelected = true
            checklistObject?.shakeTrees = true
        }
    }
    
    @IBAction func moneyTreesCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.moneyTree = false
        } else {
            sender.isSelected = true
            checklistObject?.moneyTree = true
        }
    }
    
    @IBAction func itemsCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.pickUpItems = false
        } else {
            sender.isSelected = true
            checklistObject?.pickUpItems = true
        }
    }
    
    @IBAction func turnipPricesCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.turnipPrices = false
        } else {
            sender.isSelected = true
            checklistObject?.turnipPrices = true
        }
    }
    
    @IBAction func fossilsCheckBox(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checklistObject?.digFossils = false
        } else {
            sender.isSelected = true
            checklistObject?.digFossils = true
        }
    }
}
