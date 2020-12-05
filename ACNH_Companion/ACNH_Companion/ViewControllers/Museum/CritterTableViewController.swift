//
//  CritterTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/20/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the list of critters
class CritterTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    
    let CELL_CRITTER = "critterCell"

    var indicator = UIActivityIndicatorView()
    
    var fishes: [Fish] = []
    var filteredFish: [Fish] = []
    
    var bugs: [Bug] = []
    var filteredBugs: [Bug] = []
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    var availablilityFilter = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 88.0
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        // Make sure search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        
        // Create a loading animation
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)

        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        // MARK: - Set all criters to be initialised variable and set it in museum view with navigation (using indexpath.section from selectedrow) to make either bug or fish and then change search controller to suite both
        if listenerType == .bugs {
            bugs = databaseController?.fetchAllBugs() as! [Bug]
            if !availablilityFilter {
                filteredBugs = bugs
            }
            searchController.searchBar.placeholder = "Search bug"
        } else {
            fishes = databaseController?.fetchAllFish() as! [Fish]
            if !availablilityFilter {
                filteredFish = fishes
            }
            searchController.searchBar.placeholder = "Search fish"
        }
        
        if availablilityFilter {
            getAvailableCritters()
        }
    }
    
    // MARK: - View appearance and disappearance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        
        if availablilityFilter {
            getAvailableCritters()
        }
        
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        databaseController?.saveContext()
    }
    
    // MARK: - Database Listener
    
    func onVillagerListChange(change: DatabaseChange, villagerList: [Villager]) {
        // Do nothing not called
    }
    
    func onFishListChange(change: DatabaseChange, fishList: [Fish]) {
        fishes = fishList
        tableView.reloadData()
    }
    
    func onBugListChange(change: DatabaseChange, bugList: [Bug]) {
        bugs = bugList
        tableView.reloadData()
    }
    
    // MARK: - Search Controller Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
                
        //        indicator.startAnimating()
        //        indicator.backgroundColor = UIColor.clear
        
        if listenerType == .bugs {
            if searchText.count > 0 {
                filteredBugs = bugs.filter({ (bug: Bug) -> Bool in
                    return bug.name?.lowercased().contains(searchText) ?? false
                })
            } else {
                filteredBugs = bugs
            }
        } else {
            if searchText.count > 0 {
                filteredFish = fishes.filter({ (fish: Fish) -> Bool in
                    return fish.name?.lowercased().contains(searchText) ?? false
                })
            } else {
                filteredFish = fishes
            }
        }
                
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if listenerType == .bugs {
            return filteredBugs.count
        } else {
            return filteredFish.count
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let critterCell = tableView.dequeueReusableCell(withIdentifier: CELL_CRITTER, for: indexPath) as! CollectableTableViewCell
        
        if listenerType == .bugs {
            let critter = filteredBugs[indexPath.section]
            
            // Configure the cell
            critterCell.critter = .bug
            critterCell.nameLabel.text = critter.name
            critterCell.critterImage.image = UIImage(named: critter.nameUSen! + "Icon")
            critterCell.bug = critter
            
            // Check villager properties
            if critter.discovered {
                critterCell.discoveredCheckBox.isSelected = true
            } else {
                critterCell.discoveredCheckBox.isSelected = false
            }
            if critter.donated {
                critterCell.donatedCheckBox.isSelected = true
            } else {
                critterCell.donatedCheckBox.isSelected = false
            }
            
            return critterCell
        }
        
        let critter = filteredFish[indexPath.section]
        
        // Configure the cell
        critterCell.critter = .fish
        critterCell.nameLabel.text = critter.name
        critterCell.critterImage.image = UIImage(named: critter.nameUSen! + "Icon")
        critterCell.fish = critter    // Let cell edit villager properties

        // Check villager properties
        if critter.discovered {
            critterCell.discoveredCheckBox.isSelected = true
        } else {
            critterCell.discoveredCheckBox.isSelected = false
        }
        if critter.donated {
            critterCell.donatedCheckBox.isSelected = true
        } else {
            critterCell.donatedCheckBox.isSelected = false
        }

        return critterCell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "critterDetailsSegue") {
            let destination = segue.destination as! CritterDetailsTableViewController
            
            // Set the details page to selected critter
            if let indexPath = tableView.indexPathForSelectedRow {
                if listenerType == .bugs {
                    let selectedCritter = filteredBugs[indexPath.section]
                    
                    destination.critter = .bug
                    
                    // Bug details
                    destination.name = selectedCritter.name
                    destination.nameUSen = selectedCritter.nameUSen
                    destination.sell = String(selectedCritter.price) + " Bells"
                    destination.location = selectedCritter.location
                    destination.rarity = selectedCritter.rarity
                    
                    // Time frame during day
                    if selectedCritter.isAllDay {
                        destination.time = "All Day"
                    } else {
                        destination.time = selectedCritter.time
                    }
                } else {
                    let selectedCritter = filteredFish[indexPath.section]
                    
                    destination.critter = .fish
                    
                    // Fish details
                    destination.name = selectedCritter.name
                    destination.nameUSen = selectedCritter.nameUSen
                    destination.sell = String(selectedCritter.price) + " Bells"
                    destination.location = selectedCritter.location
                    destination.rarity = selectedCritter.rarity
                    destination.shadow = selectedCritter.shadow
                    
                    // Time frame during day
                    if selectedCritter.isAllDay {
                        destination.time = "All Day"
                    } else {
                        destination.time = selectedCritter.time
                    }
                }
            }
        }
    }
    
    func getAvailableCritters() {
        let settings = databaseController?.fetchSettings()
        var southernHemisphere = true
        if settings!.count > 0 {
            southernHemisphere = settings![0].southHemisphere
        }
        
        let fishes = databaseController?.fetchAllFish()
        var availableFish: [Fish] = []
        
        for fish in fishes! {
            if southernHemisphere {
                if checkMonth(months: fish.monthSouthern) {
                    availableFish.append(fish)
                }
            } else {
                if checkMonth(months: fish.monthNorthern) {
                    availableFish.append(fish)
                }
            }
        }
        filteredFish = availableFish
        
        let bugs = databaseController?.fetchAllBugs()
        var availableBugs: [Bug] = []
        
        for bug in bugs! {
            if southernHemisphere {
                if checkMonth(months: bug.monthSouthern) {
                    availableBugs.append(bug)
                }
            } else {
                if checkMonth(months: bug.monthNorthern) {
                    availableBugs.append(bug)
                }
            }
        }
        filteredBugs = availableBugs
    }
    
    func checkMonth(months: String?) -> Bool {
        if months! == "" {
            return false
        }
        
        let trimmed = months!.replacingOccurrences(of: " ", with: "")
        let monthComponents = trimmed.components(separatedBy: "&")
        for monthComponent in monthComponents {
            let arrayStr = monthComponent.components(separatedBy: "-")
            
            let startingMonth = Int(arrayStr[0])!
            let endingMonth: Int
            if arrayStr.count > 1 {
                endingMonth = Int(arrayStr[1])!
            } else {
                endingMonth = Int(arrayStr[0])!
            }
            
            var currentMonth = startingMonth
            
            // Get the current day and month
            let dateFormatter = DateFormatter()
            let currentDateTime = Date()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            // Format the current date
            dateFormatter.locale = Locale(identifier: "en_AU")
            dateFormatter.setLocalizedDateFormatFromTemplate("M")
            let monthInt = Int(dateFormatter.string(from: currentDateTime))
            
            // Get all months
            while currentMonth != endingMonth {
                // Reset month back to Jan
                if currentMonth == 13 {
                    currentMonth = 1
                }
                
                if currentMonth == monthInt {
                    return true
                }
                
                currentMonth += 1
            }
            // Check if it is the ending month
            if currentMonth == monthInt {
                return true
            }
            
            return false
        }
        
        return false
    }

}
