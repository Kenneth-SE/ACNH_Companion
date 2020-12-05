//
//  CoreDataController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/21/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

/// The core data for the application
class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    // Request link constants
    let REQUEST_STRING = "http://acnhapi.com/"
    
    let VILLAGER_REQUEST_STRING = "http://acnhapi.com/v1/villagers/"
    let VILLAGER_ICON_REQUEST_STRING = "https://acnhapi.com/v1/icons/villagers/"
    let VILLAGER_IMAGE_REQUEST_STRING = "http://acnhapi.com/v1/images/villagers/"
    
    let FISH_REQUEST_STRING = "http://acnhapi.com/v1/fish/"
    let FISH_ICON_REQUEST_STRING = "https://acnhapi.com/v1/icons/fish/"
    let FISH_IMAGE_REQUEST_STRING = "http://acnhapi.com/v1/images/fish/"
    
    let BUGS_REQUEST_STRING = "http://acnhapi.com/v1/bugs/"
    let BUGS_ICON_REQUEST_STRING = "https://acnhapi.com/v1/icons/bugs/"
    let BUGS_IMAGE_REQUEST_STRING = "http://acnhapi.com/v1/images/bugs/"

    // Listener
    var listeners = MulticastDelegate<DatabaseListener>()
    
    // Context
    var persistentContainer: NSPersistentContainer

    // Fetched Results Controllers
    var highPriorityGoalsFetchedResultsController: NSFetchedResultsController<Goal>?
    var mediumPriorityGoalsFetchedResultsController: NSFetchedResultsController<Goal>?
    var lowPriorityGoalsFetchedResultsController: NSFetchedResultsController<Goal>?
    
    var allSettingsFetchedResultsController: NSFetchedResultsController<Settings>?
    var allRocksFetchedResultsController: NSFetchedResultsController<Rock>?
    var checklistFetchedResultsController: NSFetchedResultsController<Checklist>?
    
    var allFishFetchedResultsController: NSFetchedResultsController<Fish>?
    var donatedFishFetchedResultsController: NSFetchedResultsController<Fish>?
    
    var allBugsFetchedResultsController: NSFetchedResultsController<Bug>?
    var donatedBugsFetchedResultsController: NSFetchedResultsController<Bug>?
    
    var allVillagersFetchedResultsController: NSFetchedResultsController<Villager>?
    var currentVillagerFetchedResultsController: NSFetchedResultsController<Villager>?
    var todaysVillagersFetchedResultsController: NSFetchedResultsController<Villager>?
    var villagersBySpeciesFetchedResultsController: NSFetchedResultsController<Villager>?

    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "ACNH_Companion")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack: \(error)")
            }
        }

        super.init()
        
        // Ask permission for local notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
            if !granted {
                print("Permission was not granted!")
                return
            }
        }
        
        // If no default entries in the database we assume this is the first time the app runs
        // Create defaults in this case
        if fetchChecklist().count == 0 {
            createChecklist()
            print("Creating checklist")
        }
        if fetchAllRocks().count == 0 {
            for number in 1...6 {
                createRocks(id: number)
                print("Created rock \(number)")
            }
            saveContext()
        }
        if fetchSettings().count == 0 {
            createSettings()
            print("Creating settings")
        } else {
            resetDailyChecklist()
        }
        if fetchAllVillagers().count == 0 {
            requestVillagers()
            print("Creating villager entries")
        }
        if fetchAllFish().count == 0 {
            requestFishes()
            print("Creating fish entries")
        }
        if fetchAllBugs().count == 0 {
            requestBugs()
            print("Creating bug entries")
        }
        
        fetchEvents()
    }

    // Saves changes to core data
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    // Resets the checked off status within the checklist
    func resetDailyChecklist() {
        let settings = fetchSettings()[0]
        let previousDate = settings.date
        let previousDateComponents = Calendar.current.dateComponents([.month, .day], from: previousDate!)
        
        let currentDate = Date()
        let currentDateComponents = Calendar.current.dateComponents([.month, .day], from: currentDate)
        if previousDateComponents.day! < currentDateComponents.day! {
            settings.date = currentDate
            
            // Reset Checklist ticks
            let checklists = fetchChecklist()
            if checklists.count > 0 {
                let checklist = checklists[0]
                
                checklist.nookStop = false
                checklist.recyclingBin = false
                checklist.shakeTrees = false
                checklist.moneyTree = false
                checklist.pickUpItems = false
                checklist.turnipPrices = false
                checklist.digFossils = false
            }
            
            // Reset rocks mined
            let rocks = fetchAllRocks()
            for rock in rocks {
                rock.mined = false
            }
            
            // Reset villagers talked to
            let villagers = fetchCurrentVillagers()
            for villager in villagers {
                villager.talkedTo = false
            }
        }
    }
    
    // MARK: - Defaults
    
    // Creates the settings for the app
    func createSettings() {
        let settings = NSEntityDescription.insertNewObject(forEntityName: "Settings", into: persistentContainer.viewContext) as! Settings
        
        // Setup settings
        settings.date = Date()
        settings.southHemisphere = true
        
        saveContext()
    }
    
    // Creates the general checklist summary
    func createChecklist() {
        let checklist = NSEntityDescription.insertNewObject(forEntityName: "Checklist", into: persistentContainer.viewContext) as! Checklist
        
        // Setup checklist
        checklist.nookStop = false
        checklist.recyclingBin = false
        checklist.shakeTrees = false
        checklist.moneyTree = false
        checklist.pickUpItems = false
        checklist.turnipPrices = false
        checklist.digFossils = false
        
        saveContext()
    }
    
    // Creates the rock checklist
    func createRocks(id: Int) {
        let rock = NSEntityDescription.insertNewObject(forEntityName: "Rock", into: persistentContainer.viewContext) as! Rock
        
        // Setup checklist
        rock.id = Int32(id)
        rock.mined = false
    }
    
    // MARK: - Database Protocol Implementation
    
    // Used whenever a goal is deleted
    func deleteGoal(goal: Goal) {
        persistentContainer.viewContext.delete(goal)
    }
    
    // Used whenever a goal is created
    func addGoal(description: String, priority: Priority) {
        let goal = NSEntityDescription.insertNewObject(forEntityName: "Goal", into: persistentContainer.viewContext) as! Goal
        
        goal.goalDescription = description
        
        // Setup priority of the goal
        if priority == .high {
            goal.highPriority = true
            goal.mediumPriority = false
            goal.lowPriority = false
        } else if priority == .medium {
            goal.highPriority = false
            goal.mediumPriority = true
            goal.lowPriority = false
        } else if priority == .low {
            goal.highPriority = false
            goal.mediumPriority = false
            goal.lowPriority = true
        }
        
    }
    
    // Used to whenever a villager is added
    func addVillager(villagerData: VillagerData) -> Villager {
        let villager = NSEntityDescription.insertNewObject(forEntityName: "Villager", into: persistentContainer.viewContext) as! Villager
        
        // Setup villager properties
        villager.id = villagerData.id!
        villager.name = villagerData.name?.capitalizingFirstLetter()
        villager.nameUSen = villagerData.name
        villager.personality = villagerData.personality
        villager.birthdayStr = villagerData.birthdayStr
        villager.birthday = villagerData.birthday
        villager.species = villagerData.species
        villager.gender = villagerData.gender
        villager.catchphrase = villagerData.catchPhrase
        villager.currentResident = false
        villager.favourite = false
        villager.talkedTo = false
        
        return villager
    }
    
    // Used whenever a fish is added
    func addFish(fishData: FishData) -> Fish {
        let fish = NSEntityDescription.insertNewObject(forEntityName: "Fish", into: persistentContainer.viewContext) as! Fish
        
        // Setup fish properties
        fish.id = fishData.id!
        fish.name = fishData.name?.capitalizingFirstLetter()
        fish.nameUSen = fishData.name
        fish.shadow = fishData.shadow
        fish.price = fishData.price!
        fish.monthSouthern = fishData.monthSouthern
        fish.monthNorthern = fishData.monthNorthern
        fish.time = fishData.time
        fish.isAllDay = ((fishData.isAllDay) != nil)
        fish.isAllYear = ((fishData.isAllYear) != nil)
        fish.location = fishData.location
        fish.rarity = fishData.rarity
        fish.discovered = false
        fish.donated = false
        
        return fish
    }
    
    // Used whenever a bug is added
    func addBug(bugData: BugData) -> Bug {
        let bug = NSEntityDescription.insertNewObject(forEntityName: "Bug", into: persistentContainer.viewContext) as! Bug
        
        // Setup fish properties
        bug.id = bugData.id!
        bug.name = bugData.name?.capitalizingFirstLetter()
        bug.nameUSen = bugData.name
        bug.price = bugData.price!
        bug.monthSouthern = bugData.monthSouthern
        bug.monthNorthern = bugData.monthNorthern
        bug.time = bugData.time
        bug.isAllDay = ((bugData.isAllDay) != nil)
        bug.isAllYear = ((bugData.isAllYear) != nil)
        bug.location = bugData.location
        bug.rarity = bugData.rarity
        bug.discovered = false
        bug.donated = false
        
        return bug
    }
    
    // Adding listeners
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .villagers || listener.listenerType == .all {
            listener.onVillagerListChange(change: .update, villagerList: fetchAllVillagers())
        }
        
        if listener.listenerType == .fish || listener.listenerType == .all {
            listener.onFishListChange(change: .update, fishList: fetchAllFish())
        }
        
        if listener.listenerType == .bugs || listener.listenerType == .all {
            listener.onBugListChange(change: .update, bugList: fetchAllBugs())
        }
    }

    // Removing listeners
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }

    // MARK: - Fetch Requests
    
    // Used to get all high priority goals
    func fetchHighPriorityGoals() -> [Goal] {
        // If controller not currently initialized
        if highPriorityGoalsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
            // Sort by high priority
            let nameSortDescriptor = NSSortDescriptor(key: "highPriority", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Fetch only those that have high priority
            fetchRequest.predicate = NSPredicate(format: "highPriority == \(true)")
            highPriorityGoalsFetchedResultsController = NSFetchedResultsController<Goal>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            highPriorityGoalsFetchedResultsController?.delegate = self

            do {
                try highPriorityGoalsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var goals = [Goal]()
        if highPriorityGoalsFetchedResultsController?.fetchedObjects != nil {
            goals = (highPriorityGoalsFetchedResultsController?.fetchedObjects)!
        }

        return goals
    }
    
    // Used to get all medium priority goals
    func fetchMediumPriorityGoals() -> [Goal] {
        // If controller not currently initialized
        if mediumPriorityGoalsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
            // Sort by medium priority
            let nameSortDescriptor = NSSortDescriptor(key: "mediumPriority", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Fetch only those that have medium priority
            fetchRequest.predicate = NSPredicate(format: "mediumPriority == \(true)")
            mediumPriorityGoalsFetchedResultsController = NSFetchedResultsController<Goal>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            mediumPriorityGoalsFetchedResultsController?.delegate = self

            do {
                try mediumPriorityGoalsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var goals = [Goal]()
        if mediumPriorityGoalsFetchedResultsController?.fetchedObjects != nil {
            goals = (mediumPriorityGoalsFetchedResultsController?.fetchedObjects)!
        }

        return goals
    }
    
    // Used to get all low priority goals
    func fetchLowPriorityGoals() -> [Goal] {
        // If controller not currently initialized
        if lowPriorityGoalsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
            // Sort by low priority
            let nameSortDescriptor = NSSortDescriptor(key: "lowPriority", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Fetch only those that have low priority
            fetchRequest.predicate = NSPredicate(format: "lowPriority == \(true)")
            lowPriorityGoalsFetchedResultsController = NSFetchedResultsController<Goal>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            lowPriorityGoalsFetchedResultsController?.delegate = self

            do {
                try lowPriorityGoalsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var goals = [Goal]()
        if lowPriorityGoalsFetchedResultsController?.fetchedObjects != nil {
            goals = (lowPriorityGoalsFetchedResultsController?.fetchedObjects)!
        }

        return goals
    }
    
    // Used to get all settings
    func fetchSettings() -> [Settings] {
        // If controller not currently initialized
        if allSettingsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
            // Sort by southern hemisphere
            let nameSortDescriptor = NSSortDescriptor(key: "southHemisphere", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allSettingsFetchedResultsController = NSFetchedResultsController<Settings>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allSettingsFetchedResultsController?.delegate = self

            do {
                try allSettingsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var settings = [Settings]()
        if allSettingsFetchedResultsController?.fetchedObjects != nil {
            settings = (allSettingsFetchedResultsController?.fetchedObjects)!
        }

        return settings
    }
    
    // Used to get all checkable rocks
    func fetchAllRocks() -> [Rock] {
        // If controller not currently initialized
        if allRocksFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Rock> = Rock.fetchRequest()
            // Sort rocks by ID
            let nameSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allRocksFetchedResultsController = NSFetchedResultsController<Rock>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allRocksFetchedResultsController?.delegate = self
    
            do {
                try allRocksFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var rocks = [Rock]()
        if allRocksFetchedResultsController?.fetchedObjects != nil {
            rocks = (allRocksFetchedResultsController?.fetchedObjects)!
        }

        return rocks
    }
    
    // Used to get all checklists
    func fetchChecklist() -> [Checklist] {
        // If controller not currently initialized
        if checklistFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Checklist> = Checklist.fetchRequest()
            // Sort by NookStop status
            let nameSortDescriptor = NSSortDescriptor(key: "nookStop", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            checklistFetchedResultsController = NSFetchedResultsController<Checklist>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            checklistFetchedResultsController?.delegate = self

            do {
                try checklistFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var checklist = [Checklist]()
        if checklistFetchedResultsController?.fetchedObjects != nil {
            checklist = (checklistFetchedResultsController?.fetchedObjects)!
        }

        return checklist
    }
    
    // Used to get all events that occur today
    func fetchEvents() -> [ACNHEvent] {
        let villagers = fetchTodaysVillagers()
        
        // Setup date formatter for birthday string conversion to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_AU")
        dateFormatter.setLocalizedDateFormatFromTemplate("d-M")

        // Check each villager and turn birthdays into events
        var events: [ACNHEvent] = []
        
        for villager in villagers {
            let description = villager.name! + "'s Birthday"
            
            // Create a notification content object
            let notificationContent = UNMutableNotificationContent()
            
            // Create its details
            notificationContent.title = description
            notificationContent.body = "Make sure to gift them something nice today!"
            
            // Convert birthday string into date
            let dateTime = dateFormatter.date(from: villager.birthday!)
            
            // Create trigger
            let dateComponents = Calendar.current.dateComponents([.month, .day], from: dateTime!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            // Create our request and local notification reminder
            let request = UNNotificationRequest(identifier: villager.nameUSen!, content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            events.append(ACNHEvent(eventDescription: description, dateStr: villager.birthdayStr!))
        }
        
        return events
    }
    
    // Used to get all villagers that have their birthday today
    func fetchTodaysVillagers() -> [Villager] {
        // Get the current day and month
        let dateFormatter = DateFormatter()
        let currentDateTime = Date()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // Format the current date
        dateFormatter.locale = Locale(identifier: "en_AU")
        dateFormatter.setLocalizedDateFormatFromTemplate("d-M")
        let dateString = dateFormatter.string(from: currentDateTime)
        
        // Find villagers will certain month birthdays
        if todaysVillagersFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Villager> = Villager.fetchRequest()
            
            // Set up predicate (filter)
            let firstPredicate = NSPredicate(format: "currentResident == \(true)")
            let secondPredicate = NSPredicate(format: "birthday == %@", dateString)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [firstPredicate, secondPredicate] )
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            todaysVillagersFetchedResultsController = NSFetchedResultsController<Villager>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            todaysVillagersFetchedResultsController?.delegate = self

            do {
                try todaysVillagersFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var villagers = [Villager]()
        if todaysVillagersFetchedResultsController?.fetchedObjects != nil {
            villagers = (todaysVillagersFetchedResultsController?.fetchedObjects)!
        }

        return villagers
    }
    
    // Used to get all villagers sorted by Name
    func fetchAllVillagers() -> [Villager] {
        // If controller not currently initialized
        if allVillagersFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Villager> = Villager.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allVillagersFetchedResultsController = NSFetchedResultsController<Villager>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allVillagersFetchedResultsController?.delegate = self

            do {
                try allVillagersFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var villagers = [Villager]()
        if allVillagersFetchedResultsController?.fetchedObjects != nil {
            villagers = (allVillagersFetchedResultsController?.fetchedObjects)!
        }

        return villagers
    }
    
    // Used to get all villagers sorted by Species
    func fetchVillagersBySpecies() -> [Villager] {
        // If controller not currently initialized
        if villagersBySpeciesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Villager> = Villager.fetchRequest()
            // Sort by species
            let nameSortDescriptor = NSSortDescriptor(key: "species", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            villagersBySpeciesFetchedResultsController = NSFetchedResultsController<Villager>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            villagersBySpeciesFetchedResultsController?.delegate = self

            do {
                try villagersBySpeciesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var villagers = [Villager]()
        if villagersBySpeciesFetchedResultsController?.fetchedObjects != nil {
            villagers = (villagersBySpeciesFetchedResultsController?.fetchedObjects)!
        }

        return villagers
    }
    
    // Used to get all the current villagers within the users island
    func fetchCurrentVillagers() -> [Villager] {
        // If controller not currently initialized
        if currentVillagerFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Villager> = Villager.fetchRequest()
            // Fetch villagers that are current residents of the users island
            fetchRequest.predicate = NSPredicate(format: "currentResident == \(true)")
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            currentVillagerFetchedResultsController = NSFetchedResultsController<Villager>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            currentVillagerFetchedResultsController?.delegate = self

            do {
                try currentVillagerFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var villagers = [Villager]()
        if currentVillagerFetchedResultsController?.fetchedObjects != nil {
            villagers = (currentVillagerFetchedResultsController?.fetchedObjects)!
        }

        return villagers
    }
    
    // Used to get all fish
    func fetchAllFish() -> [Fish] {
        // If controller not currently initialized
        if allFishFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Fish> = Fish.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allFishFetchedResultsController = NSFetchedResultsController<Fish>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allFishFetchedResultsController?.delegate = self

            do {
                try allFishFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var fishes = [Fish]()
        if allFishFetchedResultsController?.fetchedObjects != nil {
            fishes = (allFishFetchedResultsController?.fetchedObjects)!
        }

        return fishes
    }
    
    // Used to get all donated fish
    func fetchDonatedFish() -> [Fish] {
        // If controller not currently initialized
        if donatedFishFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Fish> = Fish.fetchRequest()
            // Fetch all the fish that have been donated
            fetchRequest.predicate = NSPredicate(format: "donated == \(true)")
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            donatedFishFetchedResultsController = NSFetchedResultsController<Fish>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            donatedFishFetchedResultsController?.delegate = self

            do {
                try donatedFishFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var fishes = [Fish]()
        if donatedFishFetchedResultsController?.fetchedObjects != nil {
            fishes = (donatedFishFetchedResultsController?.fetchedObjects)!
        }

        return fishes
    }
    
    // Used to get all bugs
    func fetchAllBugs() -> [Bug] {
        // If controller not currently initialized
        if allBugsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Bug> = Bug.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allBugsFetchedResultsController = NSFetchedResultsController<Bug>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allBugsFetchedResultsController?.delegate = self

            do {
                try allBugsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var bugs = [Bug]()
        if allBugsFetchedResultsController?.fetchedObjects != nil {
            bugs = (allBugsFetchedResultsController?.fetchedObjects)!
        }

        return bugs
    }
    
    // Used to get all bugs donated
    func fetchDonatedBugs() -> [Bug] {
        // If controller not currently initialized
        if donatedBugsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Bug> = Bug.fetchRequest()
            // Fetch all the bugs that have been donated to the museum
            fetchRequest.predicate = NSPredicate(format: "donated == \(true)")
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            donatedBugsFetchedResultsController = NSFetchedResultsController<Bug>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            donatedBugsFetchedResultsController?.delegate = self

            do {
                try donatedBugsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }

        var bugs = [Bug]()
        if donatedBugsFetchedResultsController?.fetchedObjects != nil {
            bugs = (donatedBugsFetchedResultsController?.fetchedObjects)!
        }

        return bugs
    }

    // MARK: - Fetched Results Delegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allVillagersFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .villagers || listener.listenerType == .all {
                    listener.onVillagerListChange(change: .update, villagerList: fetchAllVillagers())
                }
            }
        } else if controller == allFishFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .fish || listener.listenerType == .all {
                    listener.onFishListChange(change: .update, fishList: fetchAllFish())
                }
            }
        }
        else if controller == allBugsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .bugs || listener.listenerType == .all {
                    listener.onBugListChange(change: .update, bugList: fetchAllBugs())
                }
            }
        }
    }
    
    // MARK: - Web Requests

    // Make a web request for all information on villagers and add it to core data
    func requestVillagers() {
        // Request all villagers
        let jsonURL = URL(string: VILLAGER_REQUEST_STRING)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            // Error check
            if let error = error {
                print(error)
                return
            }

            do {
                // Decode JSON
                let decoder = JSONDecoder()
                let villagerDataDictionary = try decoder.decode([String: VillagerData].self, from: data!)
                // Append to persistent storage
                for villagerData in villagerDataDictionary {
                    let _ = self.addVillager(villagerData: villagerData.value)
                }
                self.saveContext()
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    // Make a web request for all information on  fishes and add it to core data
    func requestFishes() {
        // Request all fishes
        let searchString = FISH_REQUEST_STRING
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            // Error check
            if let error = error {
                print(error)
                return
            }
            
            do {
                // Decode JSON
                let decoder = JSONDecoder()
                let fishDataDictionary = try decoder.decode([String: FishData].self, from: data!)
                // Append to persistent storage
                for fishData in fishDataDictionary {
                    let _ = self.addFish(fishData: fishData.value)
                }
                self.saveContext()
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
    
    // Make a web request for all information on bugs and add it to core data
    func requestBugs() {
        // Request all bugs
        let searchString = BUGS_REQUEST_STRING
        let jsonURL = URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
            // Error check
            if let error = error {
                print(error)
                return
            }
            
            do {
                // Decode JSON
                let decoder = JSONDecoder()
                let bugDataDictionary = try decoder.decode([String: BugData].self, from: data!)
                // Append to persistent storage
                for bugData in bugDataDictionary {
                    let _ = self.addBug(bugData: bugData.value)
                }
                self.saveContext()
            } catch let err {
                print(err)
            }
        }
        task.resume()
    }
}
