//
//  ImageCheckBoxTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/12/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Current villager collection view checklist
class VillagerCheckBoxTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    var villagers: [Villager] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .villagers
    @IBOutlet weak var villagerCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Updates the current residents in the collection
    func updateCurrentResidents() {
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        villagers = databaseController?.fetchCurrentVillagers() as! [Villager]
        villagerCollectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return villagers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Each cell is a tickable image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "villagerCheckBoxCell", for: indexPath) as! VillagerCollectionViewCell
        
        let villager = villagers[indexPath.section]
        
        cell.villager.setImage(UIImage(named: villager.name! + "Icon"), for: .normal)
        cell.villager.setImage(UIImage(named: "checkmark"), for: .selected)
        cell.databaseController = self.databaseController
        
        cell.villagerObject = villagers[indexPath.section]
        
        // Check villager properties
        if villager.talkedTo {
            cell.villager.isSelected = true
        } else {
            cell.villager.isSelected = false
        }
        
        return cell
    }
}
