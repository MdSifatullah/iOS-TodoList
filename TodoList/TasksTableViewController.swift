//
//  TasksTableViewController.swift
//  TodoList
//
//  Created by Yasin Shamrat on 26/1/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit
import RealmSwift

//
//protocol TasksViewControllerDelegate {
//    func catagoryObject(item: Catagory)
//}
class TasksTableViewController: UITableViewController {
    let realm = try! Realm()
    var catagory : Catagory?
    var tasks : List<Task>?
    
//    var catagoryDelegate : TasksViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = catagory?.name
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        if let all = catagory?.tasks {
            tasks = all
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = tasks![indexPath.row].name
        cell.accessoryType = tasks![indexPath.row].isCompleted == true ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(tasks![indexPath.row])
                    self.viewWillAppear(true)
                    print("Deleted task.")
                }
            } catch {
                print("Error Deleting Task.")
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
        
        do {
            try realm.write {
                tasks![indexPath.row].isCompleted = tasks![indexPath.row].isCompleted == true ? false : true
                self.viewWillAppear(true)
                print("Task Updated.")
            }
        } catch {
            print("Error updating Task.")
        }
    }
    @IBAction func onClickAddNewTask(_ sender: Any) {

        performSegue(withIdentifier: "allTaskToNewTask", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allTaskToNewTask"{
            let vc = segue.destination as! NewTaskViewController
            vc.catagory = self.catagory
        }
    }
    
    func incrementID() -> Int {
        let id = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        return id
    }
    
//  MARK:- NOtification Checklist
    // Notification permission in appDelegate
    // Set Notification Content
    // Set Notification Trigger
    // Set Notification Request
}
