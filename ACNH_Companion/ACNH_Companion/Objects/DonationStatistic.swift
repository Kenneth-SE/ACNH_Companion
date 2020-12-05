//
//  DonationStatistic.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation

/// Used for individual categories within a bar chart
struct DonationStatistic {
    var category: String
    var donated: Double
    var maxDonations: Double
}
