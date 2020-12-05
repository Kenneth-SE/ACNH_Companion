//
//  EventTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Showcases a single event
class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
