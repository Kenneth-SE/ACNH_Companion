//
//  DatabaseProtocol.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import Foundation
import UIKit

/// Used when there is a database change
enum DatabaseChange {
    case add
    case remove
    case update
}


/// Used to specify what type of data to listen to
enum ListenerType {
    case villagers
    case fish
    case bugs
    case all
}

/// Listener protocols
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onVillagerListChange(change: DatabaseChange, villagerList: [Villager])
    func onFishListChange(change: DatabaseChange, fishList: [Fish])
    func onBugListChange(change: DatabaseChange, bugList: [Bug])
}

/// Database protocols
protocol DatabaseProtocol: AnyObject {
    func deleteGoal(goal: Goal)
    func addGoal(description: String, priority: Priority)
    func fetchHighPriorityGoals() -> [Goal]
    func fetchMediumPriorityGoals() -> [Goal]
    func fetchLowPriorityGoals() -> [Goal]
    
    func resetDailyChecklist()
    func fetchSettings() -> [Settings]
    func fetchEvents() -> [ACNHEvent]
    func fetchAllRocks() -> [Rock]
    func fetchChecklist() -> [Checklist]
    
    func fetchAllVillagers() -> [Villager]
    func fetchCurrentVillagers() -> [Villager]
    func fetchVillagersBySpecies() -> [Villager]
    
    func fetchAllFish() -> [Fish]
    func fetchDonatedFish() -> [Fish]
    
    func fetchAllBugs() -> [Bug]
    func fetchDonatedBugs() -> [Bug]
    
    func addFish(fishData: FishData) -> Fish
    func addBug(bugData: BugData) -> Bug
    func addVillager(villagerData: VillagerData) -> Villager
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func saveContext()
}
