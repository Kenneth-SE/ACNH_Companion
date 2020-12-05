//
//  AboutTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 7/3/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Showcases the resources used throughout this project
class AboutTableViewController: UITableViewController {
    
    var resources: [Resource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addResources()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "websiteCell", for: indexPath)

        // Configure the cell...
        let RESOURCE = resources[indexPath.row]
        cell.textLabel?.text = RESOURCE.provider
        cell.detailTextLabel?.text = RESOURCE.usage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: resources[indexPath.row].link!) {
            UIApplication.shared.open(url)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Resources
    
    // Adds all acknowledgements
    func addResources() {
        resources.append(Resource(provider: "Nintendo", usage: "Origin of all data and images used", link: "https://www.nintendo.com.au/"))
        resources.append(Resource(provider: "Michael Wybrow", usage: "Core Data, Table Views, Web Services, etc.", link: "https://lms.monash.edu/course/view.php?id=63530"))
        resources.append(Resource(provider: "ACNH API", usage: "Critter and Villager data and images", link: "http://acnhapi.com/"))
        resources.append(Resource(provider: "Arjan", usage: "Allowing API calls", link: "https://stackoverflow.com/questions/32631184/the-resource-could-not-be-loaded-because-the-app-transport-security-policy-requi"))
        resources.append(Resource(provider: "Ollie", usage: "API Decoding", link: "https://stackoverflow.com/questions/44715494/swift-4-codable-how-to-decode-object-with-single-root-level-key"))
        resources.append(Resource(provider: "IOSCREATOR", usage: "Action Sheets", link: "https://www.ioscreator.com/tutorials/action-sheet-ios-tutorial"))
        resources.append(Resource(provider: "Suragch", usage: "Manual Table Views", link: "https://stackoverflow.com/questions/33234180/uitableview-example-for-swift"))
        resources.append(Resource(provider: "Apple", usage: "Data structures and UI", link: "https://developer.apple.com/documentation/technologies"))
        resources.append(Resource(provider: "Eugene Berezin", usage: "Cell swipe actions", link: "https://www.youtube.com/watch?v=Jl91LuRCkxg"))
        resources.append(Resource(provider: "Paul Hudson", usage: "About page link creation", link: "https://www.hackingwithswift.com/example-code/system/how-to-open-a-url-in-safari"))
        resources.append(Resource(provider: "Sean Allen", usage: "Bar Chart", link: "https://www.youtube.com/watch?v=hMyExC9swz8"))
        resources.append(Resource(provider: "Macaw", usage: "Bar Chart", link: "https://github.com/exyte/Macaw"))
        resources.append(Resource(provider: "Paul Hudson", usage: "String captialization", link: "https://www.hackingwithswift.com/example-code/strings/how-to-capitalize-the-first-letter-of-a-string"))
    }

}
