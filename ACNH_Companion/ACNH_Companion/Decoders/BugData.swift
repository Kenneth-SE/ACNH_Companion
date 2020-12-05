//
//  BugData.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/12/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Decodes the bug API call
class BugData: NSObject, Decodable {
    // General data
    var id: Int32?
    var price: Int32?
    
    // Name
    var name: String?
    
    // Availability
    var monthNorthern: String?
    var monthSouthern: String?
    var time: String?
    var isAllDay: Bool?
    var isAllYear: Bool?
    var location: String?
    var rarity: String?

    // Root keys
    private enum BugKeys: String, CodingKey {
        case id
        case name
        case availability
        case price
    }
    
    // Name container keys
    private enum nameKeys: String, CodingKey {
        case nameEN = "name-USen"
    }
    
    // Availability container keys
    private enum availabilityKeys: String, CodingKey {
        case monthNorthern = "month-northern"
        case monthSouthern = "month-southern"
        case time
        case isAllDay
        case isAllYear
        case location
        case rarity
    }
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        let rootContainer = try decoder.container(keyedBy: BugKeys.self)
        let nameContainer = try? rootContainer.nestedContainer(keyedBy: nameKeys.self, forKey: .name)
        let availabilityContainer = try? rootContainer.nestedContainer(keyedBy: availabilityKeys.self, forKey: .availability)
        
        // MARK: - General data
        
        // Decode bug ID
        if let bugID = try? rootContainer.decode(Int32.self, forKey: .id) {
            id = bugID
        }
        
        // Decode bug price
        if let bugPrice = try? rootContainer.decode(Int32.self, forKey: .price) {
            price = bugPrice
        }
        
        // MARK: - Name
        
        // Decode english name
        name = try nameContainer?.decode(String.self, forKey: .nameEN)
        
        // MARK: - Availability
        
        // Decode months that fish are available
        monthNorthern = try availabilityContainer?.decode(String.self, forKey: .monthNorthern)
        monthSouthern = try availabilityContainer?.decode(String.self, forKey: .monthSouthern)
        
        // Decode hour time frame
        time = try availabilityContainer?.decode(String.self, forKey: .time)
        
        // Decode availability for all day/year
        isAllDay = try availabilityContainer?.decode(Bool.self, forKey: .isAllDay)
        isAllYear = try availabilityContainer?.decode(Bool.self, forKey: .isAllYear)
        
        // Decode location and its rarity
        location = try availabilityContainer?.decode(String.self, forKey: .location)
        rarity = try availabilityContainer?.decode(String.self, forKey: .rarity)
    }
}
