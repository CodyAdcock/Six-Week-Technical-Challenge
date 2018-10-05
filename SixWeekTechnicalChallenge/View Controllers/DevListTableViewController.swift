//
//  DevListTableViewController.swift
//  SixWeekTechnicalChallenge
//
//  Created by Cody on 10/5/18.
//  Copyright © 2018 CreakyDoor. All rights reserved.
//2

import UIKit

class DevListTableViewController: UITableViewController {
    
    @IBOutlet weak var clearGroupsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DevGroupController.shared.createGroups()
        updateViews()
    }
    
    func updateViews(){
        //this looks like crap cuz I can't get it to reload the table view after adding a new person.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
            return DevGroupController.shared.groupList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Group \(section + 1)"
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
            let group = DevGroupController.shared.groupList[indexPath.section]
            let person = group.people[indexPath.row]
            cell.textLabel?.text = person
            return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
                let group = DevGroupController.shared.groupList[indexPath.section]
                let person = group.people[indexPath.row]
                DevGroupController.shared.deletePersonFromList(personToDelete: person)
            DevGroupController.shared.createGroups()
            updateViews()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddPersonAlertController()
        updateViews()
    }
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        DevGroupController.shared.shuffleGroups()
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
