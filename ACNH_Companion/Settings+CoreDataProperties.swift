//
//  Settings+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var southHemisphere: Bool
    @NSManaged public var date: Date?

}
