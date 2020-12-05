//
//  VillagerDetailsTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Shows the details of a specific villager
class VillagerDetailsTableViewController: UITableViewController {
    
    var nameUSen: String?
    var name: String?
    var species: String?
    var gender: String?
    var personality: String?
    var birthday: String?
    var catchphrase: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "villagerDetailsCell", for: indexPath) as! VillagerDetailsTableViewCell

        // Configure the cell...
        cell.villagerImage.image = UIImage(named: nameUSen! + "Image")
        cell.speciesLabel.text = species
        cell.genderLabel.text = gender
        cell.personalityLabel.text = personality
        cell.birthdayLabel.text = birthday
        cell.catchphraseLabel.text = catchphrase

        return cell
    }
}
