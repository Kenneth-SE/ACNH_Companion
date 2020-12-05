//
//  CritterDetailsTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class CritterDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var critterImage: UIImageView!
    @IBOutlet weak var sellLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shadowLabel: UILabel!
    @IBOutlet weak var shadowTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
