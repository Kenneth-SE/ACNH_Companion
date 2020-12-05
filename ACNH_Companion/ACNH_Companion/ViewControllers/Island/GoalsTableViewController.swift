//
//  GoalsTableViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/29/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    let HIGH_PRIORITY_SECTION = 0
    let MEDIUM_PRIORITY_SECTION = 1
    let LOW_PRIORITY_SECTION = 2
    
    let HIGH_PRIORITY_TITLE = "High Priority"
    let MEDIUM_PRIORITY_TITLE = "Medium Priority"
    let LOW_PRIORITY_TITLE = "Low Priority"
    
    var highPriorityGoals: [Goal] = []
    var mediumPriorityGoals: [Goal] = []
    var lowPriorityGoals: [Goal] = []
    
    var selectedGoal: Goal?
    
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        highPriorityGoals = databaseController?.fetchHighPriorityGoals() as! [Goal]
        mediumPriorityGoals = databaseController?.fetchMediumPriorityGoals() as! [Goal]
        lowPriorityGoals = databaseController?.fetchLowPriorityGoals() as! [Goal]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        highPriorityGoals = databaseController?.fetchHighPriorityGoals() as! [Goal]
        mediumPriorityGoals = databaseController?.fetchMediumPriorityGoals() as! [Goal]
        lowPriorityGoals = databaseController?.fetchLowPriorityGoals() as! [Goal]
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        databaseController?.saveContext()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == HIGH_PRIORITY_SECTION {
            return HIGH_PRIORITY_TITLE
        }
        if section == MEDIUM_PRIORITY_SECTION {
            return MEDIUM_PRIORITY_TITLE
        }
        return LOW_PRIORITY_TITLE
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == HIGH_PRIORITY_SECTION {
            if highPriorityGoals.count == 0 {
                return 1
            }
            return highPriorityGoals.count
        }
        if section == MEDIUM_PRIORITY_SECTION {
            if mediumPriorityGoals.count == 0 {
                return 1
            }
            return mediumPriorityGoals.count
        }
        if lowPriorityGoals.count == 0 {
            return 1
        }
        return lowPriorityGoals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalsCell", for: indexPath)
        let emptyCell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath)

        // Configure the cell...
        emptyCell.textLabel?.text = "No goals of this priority set yet!"
        
        if indexPath.section == HIGH_PRIORITY_SECTION {
            if highPriorityGoals.count == 0 {
                return emptyCell
            }
            cell.textLabel?.text = highPriorityGoals[indexPath.row].goalDescription
        } else if indexPath.section == MEDIUM_PRIORITY_SECTION {
            if mediumPriorityGoals.count == 0 {
                return emptyCell
            }
            cell.textLabel?.text = mediumPriorityGoals[indexPath.row].goalDescription
        } else if indexPath.section == LOW_PRIORITY_SECTION {
            if lowPriorityGoals.count == 0 {
                return emptyCell
            }
            cell.textLabel?.text = lowPriorityGoals[indexPath.row].goalDescription
        }

        return cell
    }
    
    func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _,_,_ in
            guard let self = self else {return}
            var goal: Goal?
            
            if indexPath.section == self.HIGH_PRIORITY_SECTION {
                goal = self.highPriorityGoals[indexPath.row]
                self.highPriorityGoals.remove(at: indexPath.row)
                self.databaseController?.deleteGoal(goal: goal!)
            } else if indexPath.section == self.MEDIUM_PRIORITY_SECTION {
                goal = self.mediumPriorityGoals[indexPath.row]
                self.mediumPriorityGoals.remove(at: indexPath.row)
                self.databaseController?.deleteGoal(goal: goal!)
            } else if indexPath.section == self.LOW_PRIORITY_SECTION {
                goal = self.lowPriorityGoals[indexPath.row]
                self.lowPriorityGoals.remove(at: indexPath.row)
                self.databaseController?.deleteGoal(goal: goal!)
            }
            
            self.tableView.reloadData()
        })
        
        return action
    }
    
    func priority(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Priority", handler: { [weak self] _,_,_ in
            guard let self = self else {return}
            
            let alert = UIAlertController(title: "Priority", message: "Please Select an Option:", preferredStyle: .actionSheet)

            alert.addAction(UIAlertAction(title: "High", style: .default , handler: { (UIAlertAction) in
                print("User click High button")
                
                var goals: [Goal] = []
                
                if indexPath.section == self.HIGH_PRIORITY_SECTION {
                    return
                } else if indexPath.section == self.MEDIUM_PRIORITY_SECTION {
                    goals = self.mediumPriorityGoals
                    self.mediumPriorityGoals.remove(at: indexPath.row)
                } else if indexPath.section == self.LOW_PRIORITY_SECTION {
                    goals = self.lowPriorityGoals
                    self.lowPriorityGoals.remove(at: indexPath.row)
                }
                
                self.highPriorityGoals.append(contentsOf: goals)
                
                goals[indexPath.row].highPriority = true
                goals[indexPath.row].mediumPriority = false
                goals[indexPath.row].lowPriority = false
                
                self.tableView.reloadData()
            }))

            alert.addAction(UIAlertAction(title: "Medium", style: .default , handler: { (UIAlertAction)in
                print("User click Medium button")
                
                var goals: [Goal] = []
                
                if indexPath.section == self.HIGH_PRIORITY_SECTION {
                    goals = self.highPriorityGoals
                    self.highPriorityGoals.remove(at: indexPath.row)
                } else if indexPath.section == self.MEDIUM_PRIORITY_SECTION {
                    return
                } else if indexPath.section == self.LOW_PRIORITY_SECTION {
                    goals = self.lowPriorityGoals
                    self.lowPriorityGoals.remove(at: indexPath.row)
                }
                
                self.mediumPriorityGoals.append(contentsOf: goals)
                
                goals[indexPath.row].highPriority = false
                goals[indexPath.row].mediumPriority = true
                goals[indexPath.row].lowPriority = false
                
                self.tableView.reloadData()
            }))

            alert.addAction(UIAlertAction(title: "Low", style: .default , handler: { (UIAlertAction)in
                print("User click Low button")
                
                var goals: [Goal] = []
                
                if indexPath.section == self.HIGH_PRIORITY_SECTION {
                    goals = self.highPriorityGoals
                    self.highPriorityGoals.remove(at: indexPath.row)
                } else if indexPath.section == self.MEDIUM_PRIORITY_SECTION {
                    goals = self.mediumPriorityGoals
                    self.mediumPriorityGoals.remove(at: indexPath.row)
                } else if indexPath.section == self.LOW_PRIORITY_SECTION {
                    return
                }
                
                self.lowPriorityGoals.append(contentsOf: goals)
                
                goals[indexPath.row].highPriority = false
                goals[indexPath.row].mediumPriority = false
                goals[indexPath.row].lowPriority = true
                
                self.tableView.reloadData()
            }))

            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (UIAlertAction)in
                print("User click Dismiss button")
            }))

            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            self.tableView.reloadData()
        })
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Check if the section had any goals
        if indexPath.section == self.HIGH_PRIORITY_SECTION && highPriorityGoals.count == 0 {
            return UISwipeActionsConfiguration(actions: [])
        } else if indexPath.section == self.MEDIUM_PRIORITY_SECTION && mediumPriorityGoals.count == 0 {
            return UISwipeActionsConfiguration(actions: [])
        } else if indexPath.section == self.LOW_PRIORITY_SECTION && lowPriorityGoals.count == 0 {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        // If goal exists give it edit actions
        let priority = self.priority(rowIndexPathAt: indexPath)
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [delete, priority])
        return swipe
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HIGH_PRIORITY_SECTION && highPriorityGoals.count > 0 {
            selectedGoal = highPriorityGoals[indexPath.row]
        } else if indexPath.section == MEDIUM_PRIORITY_SECTION && mediumPriorityGoals.count > 0 {
            selectedGoal = mediumPriorityGoals[indexPath.row]
        } else if indexPath.section == LOW_PRIORITY_SECTION && lowPriorityGoals.count > 0 {
            selectedGoal = lowPriorityGoals[indexPath.row]
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addGoalSegue" {
            let destination = segue.destination as! GoalEditorViewController
            destination.editingGoal = false
            destination.title = "Add Goal"
            
        } else if segue.identifier == "editGoalSegue" {
            let destination = segue.destination as! GoalEditorViewController
            destination.editingGoal = true
            destination.goal = selectedGoal
            destination.title = "Edit Goal"
        }
    }

}
