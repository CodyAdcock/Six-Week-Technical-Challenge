//
//  DevListTableViewController.swift
//  SixWeekTechnicalChallenge
//
//  Created by Cody on 10/5/18.
//  Copyright © 2018 CreakyDoor. All rights reserved.
//

import UIKit

class DevListTableViewController: UITableViewController {
    
    @IBOutlet weak var clearGroupsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !DevGroupController.shared.groupList.isEmpty{
            return DevGroupController.shared.groupList.count
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !DevGroupController.shared.groupList.isEmpty{
            return "Group \(section + 1)"
        }else{
            return "All People"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !DevGroupController.shared.groupList.isEmpty{
            return 2
        }else{
            return DevGroupController.shared.devList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        if !DevGroupController.shared.groupList.isEmpty{
            let group = DevGroupController.shared.groupList[indexPath.section]
            let person = group.people[indexPath.row]
            cell.textLabel?.text = person
            return cell
        }else{
            let person = DevGroupController.shared.devList[indexPath.row]
            cell.textLabel?.text = person
            return cell
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if !DevGroupController.shared.groupList.isEmpty{
                let group = DevGroupController.shared.groupList[indexPath.section]
                let person = group.people[indexPath.row]
                DevGroupController.shared.deletePersonFromList(personToDelete: person)
            }else{
                let person = DevGroupController.shared.devList[indexPath.row]
                DevGroupController.shared.deletePersonFromList(personToDelete: person)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateViews()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddPersonAlertController()
        updateViews()
    }
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        DevGroupController.shared.createGroups()
        updateViews()
    }
    @IBAction func clearGroupsButtonTapped(_ sender: Any) {
        DevGroupController.shared.groupList = []
        updateViews()
    }
    
    func presentAddPersonAlertController(){
        var personNameTextField: UITextField?
        let alertController = UIAlertController(title: "Add to the list", message: "", preferredStyle: .alert)
        alertController.addTextField{(textField) in
            textField.placeholder = "Enter a person's name here"
            personNameTextField = textField
            
        }
        //define new actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default){(_) in
            guard let person = personNameTextField?.text else {return}
            DevGroupController.shared.addPerson(person: person)
            self.updateViews()
        }
        //add defined actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
