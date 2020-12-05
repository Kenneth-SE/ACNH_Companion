//
//  RockCheckBoxTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/14/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Rock collection view checklist
class RockCheckBoxTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var rocks: [Rock] = []
    weak var databaseController: DatabaseProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateCurrentRocks()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Updates the rocks in the collection
    func updateCurrentRocks() {
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        rocks = databaseController?.fetchAllRocks() as! [Rock]
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Each cell is a tickable image
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rockCheckBoxCell", for: indexPath) as! RockCollectionViewCell
        
        cell.rock.setImage(UIImage(named: "rock-1"), for: .normal)
        cell.rock.setImage(UIImage(named: "rockCheckmark"), for: .selected)
        
        cell.databaseController = self.databaseController
        
        let rock = rocks[indexPath.section]
        cell.rockObject = rock
        
        // Check rock properties
        if rock.mined {
            cell.rock.isSelected = true
        } else {
            cell.rock.isSelected = false
        }
        
        return cell
    }
}
