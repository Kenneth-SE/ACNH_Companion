//
//  Rock+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Rock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rock> {
        return NSFetchRequest<Rock>(entityName: "Rock")
    }

    @NSManaged public var id: Int32
    @NSManaged public var mined: Bool

}
