//
//  VillagerDetailsTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to show all details of a specific villager
class VillagerDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var catchphraseLabel: UILabel!
    @IBOutlet weak var villagerImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
