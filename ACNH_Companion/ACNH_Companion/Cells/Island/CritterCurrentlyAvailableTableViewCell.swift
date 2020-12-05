//
//  CritterCurrentlyAvailableTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 7/2/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used to show the currently available critters and its stats
class CritterCurrentlyAvailableTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var discoveredLabel: UILabel!
    @IBOutlet weak var leavingLabel: UILabel!
    @IBOutlet weak var allLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
