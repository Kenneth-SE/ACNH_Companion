//
//  HomeTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the home view
class HomeTableViewController: UITableViewController {
    
    let IMAGE_CHECKLIST_CELL = 0
    let CHECKLIST_SECTION = 0
    let CHECKLIST_CELL = 2
    let CHART_SECTION = 1
    let CHART_CELL = 1
    let EVENT_SECTION = 2
    let EVENT_CELL = 1
    
    let CHECKLIST_CELL_HEIGHT = 340
    let TOTAL_SECTIONS = 3
    let FONT_SIZE = 22
    
    weak var databaseController: DatabaseProtocol?
    
    var dateFormatter = DateFormatter()
    var currentDateTime = Date()
    var hemisphere = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none;
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter = DateFormatter()
        currentDateTime = Date()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // US English Locale (en_US)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        
        // Reset checklist if it is a new day
        databaseController?.resetDailyChecklist()
        
        checkHemisphere()
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        // Save context
        databaseController?.saveContext()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return TOTAL_SECTIONS
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CHECKLIST_SECTION {
            return CHECKLIST_CELL
        }
        if section == CHART_SECTION {
            return CHART_CELL
        }
        if section == EVENT_SECTION {
            return EVENT_CELL
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == CHECKLIST_SECTION {
            if indexPath.row == IMAGE_CHECKLIST_CELL {
                let imageCheckBoxCell = tableView.dequeueReusableCell(withIdentifier: "imageTableCell", for: indexPath) as! ImageTableViewCell
                imageCheckBoxCell.imageTableView.reloadData()
                return imageCheckBoxCell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "checklistCell", for: indexPath) as! ChecklistTableViewCell
            
            let checklist = databaseController?.fetchChecklist()[0]
            cell.checklistObject = checklist
            
            // Check checklist properties
            if checklist!.nookStop {
                cell.nookStop.isSelected = true
            } else {
                cell.nookStop.isSelected = false
            }
            if checklist!.recyclingBin {
                cell.recyclingBin.isSelected = true
            } else {
                cell.recyclingBin.isSelected = false
            }
            if checklist!.shakeTrees {
                cell.shakeTrees.isSelected = true
            } else {
                cell.shakeTrees.isSelected = false
            }
            if checklist!.moneyTree {
                cell.moneyTrees.isSelected = true
            } else {
                cell.moneyTrees.isSelected = false
            }
            if checklist!.pickUpItems {
                cell.items.isSelected = true
            } else {
                cell.items.isSelected = false
            }
            if checklist!.turnipPrices {
                cell.turnipPrices.isSelected = true
            } else {
                cell.turnipPrices.isSelected = false
            }
            if checklist!.digFossils {
                cell.fossils.isSelected = true
            } else {
                cell.fossils.isSelected = false
            }
            
            return cell
        } else if indexPath.section == CHART_SECTION {
            let statsCell = tableView.dequeueReusableCell(withIdentifier: "barChartCell", for: indexPath) as! DonationStatisticsTableViewCell
            statsCell.showChart()
            return statsCell
        } else {
            let eventsCell = tableView.dequeueReusableCell(withIdentifier: "allEventsCell", for: indexPath) as! AllEventsTableViewCell
            
            eventsCell.events = databaseController?.fetchEvents() as! [ACNHEvent]
            eventsCell.eventsTableView.reloadData()
            
            return eventsCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == CHECKLIST_SECTION {
            return dateFormatter.string(from: currentDateTime) + ", " + hemisphere + "\nDaily Checklist"
        } else if section == CHART_SECTION {
            return "Museum Summary"
        } else if section == EVENT_SECTION {
            return "Events"
        }
        return ""
    }
    
    @IBAction func changeHemisphereButton(_ sender: Any) {
        let alert = UIAlertController(title: "Hemisphere", message: "Please Select an Option:", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "North", style: .default , handler: { (UIAlertAction) in
            let settingsGroup = self.databaseController?.fetchSettings()
            if settingsGroup!.count > 0 {
                settingsGroup![0].southHemisphere = false
            }
            self.checkHemisphere()
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "South", style: .default , handler: { (UIAlertAction) in
            let settingsGroup = self.databaseController?.fetchSettings()
            if settingsGroup!.count > 0 {
                settingsGroup![0].southHemisphere = true
            }
            self.checkHemisphere()
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (UIAlertAction) in }))

        self.present(alert, animated: true, completion: {})
    }
    
    func checkHemisphere() {
        // Check hemisphere
        let settings = databaseController?.fetchSettings() as! [Settings]
        if settings.count > 0 {
            if settings[0].southHemisphere {
                hemisphere = "South Hemisphere"
            } else {
                hemisphere = "North Hemisphere"
            }
        }
    }
    
}
