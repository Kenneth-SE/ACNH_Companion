//
//  Goal+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 7/2/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var highPriority: Bool
    @NSManaged public var mediumPriority: Bool
    @NSManaged public var lowPriority: Bool
    @NSManaged public var goalDescription: String?

}
