//
//  DonationStatisticsTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Used show the bar graph summary of the collected critters
class DonationStatisticsTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: MuseumChart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showChart() {
        //chartView.node = MuseumChart.createChart()
        chartView.contentMode = .scaleAspectFit
        MuseumChart.playAnimations()
    }

}
