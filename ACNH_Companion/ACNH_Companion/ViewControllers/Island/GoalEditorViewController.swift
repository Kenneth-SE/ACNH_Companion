//
//  GoalEditorViewController.swift
//  ACNH_Companion
//
//  Created by user160075 on 6/30/20.
//  Copyright © 2020 edu.monash. All rights reserved.
//

import UIKit

class GoalEditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    weak var databaseController: DatabaseProtocol?
    var goal: Goal?
    var editingGoal: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionTextField.delegate = self
        
        // Get the database controller once from the App Delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        if editingGoal! {
            descriptionTextField.text = goal?.goalDescription
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // Get information from ingredient list and measurement text field
        let goalDescription = descriptionTextField.text!
        let priority = prioritySegmentedControl.titleForSegment(at: prioritySegmentedControl.selectedSegmentIndex)!
        
        // Display alert if measurement amount not provided
        if goalDescription == "" {
            let errorMsg = "Please ensure all fields are filled:\n- Must provide a goal description"
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        if editingGoal! {
            goal?.goalDescription = goalDescription
            if priority == "High" {
                goal?.highPriority = true
                goal?.mediumPriority = false
                goal?.lowPriority = false
            } else if priority == "Medium" {
                goal?.highPriority = false
                goal?.mediumPriority = true
                goal?.lowPriority = false
            } else if priority == "Low" {
                goal?.highPriority = false
                goal?.mediumPriority = false
                goal?.lowPriority = true
            }
        } else {
            if priority == "High" {
                databaseController?.addGoal(description: goalDescription, priority: .high)
            } else if priority == "Medium" {
                databaseController?.addGoal(description: goalDescription, priority: .medium)
            } else if priority == "Low" {
                databaseController?.addGoal(description: goalDescription, priority: .low)
            }
        }
        
        databaseController?.saveContext()
        
        navigationController?.popViewController(animated: true)
        return
    }
    
    // MARK: - Alert
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
