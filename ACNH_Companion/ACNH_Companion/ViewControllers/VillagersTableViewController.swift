//
//  VillagersTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 5/16/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the list of villagers
class VillagersTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {
    
    let CELL_VILLAGER = "villagerCell"
    
    var indicator = UIActivityIndicatorView()
    
    var villagers: [Villager] = []
    var filteredVillagers: [Villager] = []
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .villagers

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 88.0
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search villager"
        // Make sure search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // This view controller decides how the search controller is presented.
        definesPresentationContext = true
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        villagers = databaseController?.fetchAllVillagers() as! [Villager]
        filteredVillagers = villagers
    }
    
    // MARK: - View appearance and disappearance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Save context
        databaseController?.saveContext()
        
        // Remove listeners
        databaseController?.removeListener(listener: self)
        
        // Reset title size
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Database Listener
    
    func onVillagerListChange(change: DatabaseChange, villagerList: [Villager]) {
        villagers = villagerList
        tableView.reloadData()
    }
    
    func onFishListChange(change: DatabaseChange, fishList: [Fish]) {
        // Do nothing not called
    }
    
    func onBugListChange(change: DatabaseChange, bugList: [Bug]) {
        // Do nothing not called
    }
    
    // MARK: - Search Controller Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredVillagers = villagers.filter({ (villager: Villager) -> Bool in
                return villager.name?.lowercased().contains(searchText) ?? false
            })
        } else {
            filteredVillagers = villagers
        }
                
        tableView.reloadData()
    }

    // MARK: - Table view data source

    // Amount of villagers
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredVillagers.count
    }

    // Each villager is one cell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup
        let villagerCell = tableView.dequeueReusableCell(withIdentifier: CELL_VILLAGER, for: indexPath) as! VillagerTableViewCell
        let villager = filteredVillagers[indexPath.section]

        // Configure the cell
        villagerCell.nameLabel.text = villager.name
        villagerCell.villagerImage.image = UIImage(named: villager.name! + "Icon")
        villagerCell.villager = villager    // Let cell edit villager properties
        
        // Check villager properties
        if villager.currentResident {
            villagerCell.currentResidentCheckBox.isSelected = true
        } else {
            villagerCell.currentResidentCheckBox.isSelected = false
        }
        if villager.favourite {
            villagerCell.favouriteCheckBox.isSelected = true
        } else {
            villagerCell.favouriteCheckBox.isSelected = false
        }

        return villagerCell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "villagerDetailsSegue") {
            let destination = segue.destination as! VillagerDetailsTableViewController
            
            // Set the details page to selected critter
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedVillager = filteredVillagers[indexPath.section]
                    
                destination.title = selectedVillager.name
                destination.nameUSen = selectedVillager.nameUSen
                
                // Villager details
                destination.species = selectedVillager.species
                destination.gender = selectedVillager.gender
                destination.personality = selectedVillager.personality
                destination.birthday = selectedVillager.birthdayStr
                destination.catchphrase = selectedVillager.catchphrase
            }
        }
    }
    
    @IBAction func filterButton(_ sender: Any) {
        let alert = UIAlertController(title: "Filter villagers", message: "Please Select an Option:", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Name", style: .default , handler: { (UIAlertAction) in
            self.filteredVillagers = self.databaseController?.fetchAllVillagers() as! [Villager]
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Species", style: .default , handler: { (UIAlertAction) in
            self.filteredVillagers = self.databaseController?.fetchVillagersBySpecies() as! [Villager]
            self.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (UIAlertAction) in }))

        self.present(alert, animated: true, completion: {})
    }
}
