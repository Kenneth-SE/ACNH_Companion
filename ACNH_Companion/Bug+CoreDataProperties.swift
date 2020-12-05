//
//  Bug+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/12/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Bug {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bug> {
        return NSFetchRequest<Bug>(entityName: "Bug")
    }

    @NSManaged public var id: Int32
    @NSManaged public var isAllDay: Bool
    @NSManaged public var isAllYear: Bool
    @NSManaged public var location: String?
    @NSManaged public var monthNorthern: String?
    @NSManaged public var monthSouthern: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var rarity: String?
    @NSManaged public var time: String?
    @NSManaged public var nameUSen: String?
    @NSManaged public var discovered: Bool
    @NSManaged public var donated: Bool

}
