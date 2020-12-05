//
//  IslandTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class IslandTableViewController: UITableViewController {
    
    let GOAL_SECTION = 0
    let BUGS_SECTION = 1
    let FISH_SECTION = 2
    
    weak var databaseController: DatabaseProtocol?
    
    var bugs: [Bug] = []
    var filteredBugs: [Bug] = []
    var caughtBugs: Int = 0
    var leavingBugs: Int = 0
    var fish: [Fish] = []
    var filteredFish: [Fish] = []
    var caughtFish: Int = 0
    var leavingFish: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 186.0
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        getAvailableCritters()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == GOAL_SECTION {
            // Setup
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "goalsCategoryCell", for: indexPath) as! CategoryTableViewCell

            // Configure the cell
            categoryCell.categoryImage.image = #imageLiteral(resourceName: "checkmark")
            categoryCell.categoryLabel.text = "Goals"

            return categoryCell
        } else if indexPath.section == BUGS_SECTION {
            // Setup
            let availablilityCell = tableView.dequeueReusableCell(withIdentifier: "availabilityCell", for: indexPath) as! CritterCurrentlyAvailableTableViewCell

            // Configure the cell
            availablilityCell.cellTitleLabel?.text = "Available bugs this month"
            availablilityCell.discoveredLabel?.text = String(caughtBugs)
            availablilityCell.leavingLabel?.text = String(leavingBugs)
            availablilityCell.allLabel?.text = String(filteredBugs.count)

            return availablilityCell
        }
        // Setup
        let availablilityCell = tableView.dequeueReusableCell(withIdentifier: "availabilityCell", for: indexPath) as! CritterCurrentlyAvailableTableViewCell

        // Configure the cell
        availablilityCell.cellTitleLabel?.text = "Available fish this month"
        availablilityCell.discoveredLabel?.text = String(caughtFish)
        availablilityCell.leavingLabel?.text = String(leavingFish)
        availablilityCell.allLabel?.text = String(filteredFish.count)

        return availablilityCell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "critterTableSegue") {
            let destination = segue.destination as! CritterTableViewController
            
            // Set the details page to selected critter
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == BUGS_SECTION {
                    destination.title = "Bugs"
                    destination.listenerType = .bugs
                } else if indexPath.section == FISH_SECTION {
                    destination.title = "Fish"
                    destination.listenerType = .fish
                }
                destination.availablilityFilter = true
            }
        }
    }
    
    func getAvailableCritters() {
        caughtBugs = 0
        leavingBugs = 0
        caughtFish = 0
        leavingFish = 0
        
        let settings = databaseController?.fetchSettings()
        var southernHemisphere = true
        if settings!.count > 0 {
            southernHemisphere = settings![0].southHemisphere
        }
        
        let fishes = databaseController?.fetchAllFish()
        var availableFish: [Fish] = []
        
        for fish in fishes! {
            if southernHemisphere {
                if checkMonth(months: fish.monthSouthern, isBug: false) {
                    availableFish.append(fish)
                    
                    if fish.discovered {
                        caughtFish += 1
                    }
                }
            } else {
                if checkMonth(months: fish.monthNorthern, isBug: false) {
                    availableFish.append(fish)
                    
                    if fish.discovered {
                        caughtFish += 1
                    }
                }
            }
        }
        filteredFish = availableFish
        
        let bugs = databaseController?.fetchAllBugs()
        var availableBugs: [Bug] = []
        
        for bug in bugs! {
            if southernHemisphere {
                if checkMonth(months: bug.monthSouthern, isBug: true) {
                    availableBugs.append(bug)
                    
                    if bug.discovered {
                        caughtBugs += 1
                    }
                }
            } else {
                if checkMonth(months: bug.monthNorthern, isBug: true) {
                    availableBugs.append(bug)
                    
                    if bug.discovered {
                        caughtBugs += 1
                    }
                }
            }
        }
        filteredBugs = availableBugs
    }
    
    func checkMonth(months: String?, isBug: Bool) -> Bool {
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
                if isBug {
                    leavingBugs += 1
                } else {
                    leavingFish += 1
                }
                return true
            }
            
            return false
        }
        
        return false
    }

}
