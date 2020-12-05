//
//  Checklist+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Checklist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checklist> {
        return NSFetchRequest<Checklist>(entityName: "Checklist")
    }

    @NSManaged public var digFossils: Bool
    @NSManaged public var moneyTree: Bool
    @NSManaged public var nookStop: Bool
    @NSManaged public var pickUpItems: Bool
    @NSManaged public var recyclingBin: Bool
    @NSManaged public var shakeTrees: Bool
    @NSManaged public var turnipPrices: Bool

}
