//
//  FishData.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Decodes the fish API call
class FishData: NSObject, Decodable {
    // General data
    var id: Int32?
    var shadow: String?
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
    private enum FishKeys: String, CodingKey {
        case id
        case name
        case availability
        case shadow
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
        let rootContainer = try decoder.container(keyedBy: FishKeys.self)
        let nameContainer = try? rootContainer.nestedContainer(keyedBy: nameKeys.self, forKey: .name)
        let availabilityContainer = try? rootContainer.nestedContainer(keyedBy: availabilityKeys.self, forKey: .availability)
        
        // MARK: - General data
        
        // Decode fish ID
        if let fishID = try? rootContainer.decode(Int32.self, forKey: .id) {
            id = fishID
        }
        
        // Decode fish shadow description
        if let fishShadow = try? rootContainer.decode(String.self, forKey: .shadow) {
            shadow = fishShadow
        }
        
        // Decode fish price
        if let fishPrice = try? rootContainer.decode(Int32.self, forKey: .price) {
            price = fishPrice
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
