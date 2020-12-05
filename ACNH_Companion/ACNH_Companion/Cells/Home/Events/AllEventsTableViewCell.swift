//
//  AllEventsTableViewCell.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/19/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

/// Lists all the events for the day
class AllEventsTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var eventsTableView: UITableView!
    
    var events: [ACNHEvent] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events.count == 0 {
            return 1
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if events.count == 0 {
            // If there is not event set a default cell to notify user
            let basicCell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
            basicCell?.textLabel?.text = "No events currently!"
                
            return basicCell!
        }
        
        // Show the event
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableViewCell
        
        cell.eventLabel.text = events[indexPath.row].eventDescription
        cell.dateLabel.text = events[indexPath.row].dateStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today"
    }
}
