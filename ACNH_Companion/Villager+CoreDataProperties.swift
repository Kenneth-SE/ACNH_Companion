//
//  Villager+CoreDataProperties.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/18/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//
//

import Foundation
import CoreData


extension Villager {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Villager> {
        return NSFetchRequest<Villager>(entityName: "Villager")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var birthdayStr: String?
    @NSManaged public var catchphrase: String?
    @NSManaged public var currentResident: Bool
    @NSManaged public var favourite: Bool
    @NSManaged public var gender: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var nameUSen: String?
    @NSManaged public var personality: String?
    @NSManaged public var species: String?
    @NSManaged public var talkedTo: Bool

}
