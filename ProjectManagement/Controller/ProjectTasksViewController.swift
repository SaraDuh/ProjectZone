//
//  ProjectTasksViewController.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class ProjectTasksViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var assignedMember: UITextField!
    @IBOutlet weak var tasksTable: UITableView!
    
    @IBOutlet weak var projectCost: UILabel!
    
    var totalProjectCost = 0.0
    
    
    var TasksReference : DatabaseReference!
    var projectkey2  : String?
    var tasksList = [Task]()
    var tasksKeys = [String]()
    let userID = Auth.auth().currentUser?.uid
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! projectTasksTableViewCell
        
        let task: Task
        task = tasksList [indexPath.row]
        cell.Name.text = task.name
        cell.AssigendMember.text = task.assignedMember
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TasksReference = Database.database().reference().child("users").child(userID!).child("Projects").child(projectkey2!)
        
        //observing the data changes
        TasksReference.child("Tasks").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.tasksList.removeAll()
                self.totalProjectCost = 0.0
                //iterating through all the values
                for tasks in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let taskObject = tasks.value as? [String: AnyObject]
                    let name = taskObject?["Name"]
                    let assignedMember = taskObject?["Assigned Member"]
                    let taskId = tasks.key
                    if (name != nil &&  assignedMember != nil){
                    self.tasksKeys.append(taskId)
                    //creating task object with model and fetched values
                    let task = Task (name: name as? String , assignedMember: assignedMember as!String?, id: taskId)
                    //appending it to list
                    self.tasksList.append(task)
                    let ref = Database.database().reference()
                ref.child("users").child(self.userID!).child("Projects").child(self.projectkey2!).child("Tasks").child(taskId).child("Total Cost").observeSingleEvent(of: .value, with: { (snapshot) in
                    let costObject = snapshot.value as? [String: AnyObject]
                    var ProjectCost0  = costObject?["Total Cost"]
                    if (ProjectCost0 == nil){
                    ProjectCost0 = "0" as AnyObject }
                    guard let ProjectCost = ProjectCost0 else { return }
                    let ProjectCost1 = "\(ProjectCost)"
                    print ()
                    print ("Project Cost: \(ProjectCost1)")

                    let tprojectCost = Double(ProjectCost1)
                    print ("cost string: \(ProjectCost1 as Any)")
                    print ("cost double: \(tprojectCost as Any)")
                    self.totalProjectCost = self.totalProjectCost + tprojectCost!
                    self.projectCost.text = "\(self.totalProjectCost) SR"
                    let ref = Database.database().reference()
                    let projectCostDB = ["Total Cost" : self.totalProjectCost]; ref.child("users").child(self.userID!).child("Projects").child(self.projectkey2!).child("Total Cost").setValue(projectCostDB)
                    self.tasksTable.reloadData()
                    print ()
                    print ("Project Cost DB: \(self.totalProjectCost)")
                    

                        })
                    }
                }
                //reloading the tableview
                self.tasksTable.reloadData()
            }
        })

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPressed(_ sender: Any) {
        let ref = Database.database().reference()
        let key = ref.childByAutoId().key
        
        if (self.Name.text?.isEmpty)! || (self.assignedMember.text?.isEmpty)!
        {
            let alertController = UIAlertController(title: "Failed to add task!", message: "Task is not Added! Please fill the required information", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            
            let task = ["Name" : self.Name.text , "Assigned Member" : self.assignedMember.text]
            ref.child("users").child(userID!).child("Projects").child(projectkey2!).child("Tasks").child(key!).setValue(task)
            
            let alertController = UIAlertController(title: "Added successfully!", message: "Your task has been added successfully to the project", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            self.Name.text = ""
            self.assignedMember.text = ""
            
        }
        
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let pID = storyboard?.instantiateViewController(withIdentifier: "ProjectResourcesViewController") as? ProjectResourcesViewController
//        pID?.taskKey = tasksKeys[indexPath.row]
//        print (tasksKeys[indexPath.row])
//          pID?.projectkey3 = self.projectkey2
//        self.navigationController?.pushViewController(pID!, animated: true)
//
//    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let task1  = tasksList[indexPath.row]
            //building an alert
            let alertController = UIAlertController(title: task1.name, message: "Give new values to update ", preferredStyle: .alert)
    
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
                //getting id
                let id = task1.id
                //getting new values
                let name = alertController.textFields?[0].text
                let assignedMember = alertController.textFields?[1].text
    
                //calling the update method to update artist
                self.updateTask(id: id!, name: name!, assignedMember: assignedMember!)
            }
    
    
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
    
                //deleting class
                self.deleteTask(id: task1.id!)
            }
    
    
            let cancelAction = UIAlertAction(title: "Cancle", style: .cancel) { (_) in }
    
            //adding two textfields to alert
            alertController.addTextField { (textField) in
                textField.text = task1.name
            }
            alertController.addTextField { (textField) in
                textField.text = task1.assignedMember
            }
     let goAction = UIAlertAction(title: "Go to Resources", style: .default) { (_) in
    
    let pID = self.storyboard?.instantiateViewController(withIdentifier: "ProjectResourcesViewController") as? ProjectResourcesViewController
        pID?.taskKey = self.tasksKeys[indexPath.row]
        print (self.tasksKeys[indexPath.row])
    pID?.projectkey3 = self.projectkey2
    self.navigationController?.pushViewController(pID!, animated: true)
                }
    
            //adding action
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
                alertController.addAction(goAction)
    
            //presenting dialog
            present(alertController, animated: true, completion: nil)
        }
    
    func updateTask(id:String, name:String, assignedMember:String){
        //creating artist with the new given values
        let task1 = ["Name":name, "Assigned Member": assignedMember ]
        
        //updating the class using the key of the class
        let ref2 = Database.database().reference().child("users").child(userID!).child("Projects").child(projectkey2!).child("Tasks")
        ref2.child(id).setValue(task1)
    }
    
    //Function to make table view backgound clear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }
    
    func deleteTask(id:String){
      let ref2 = Database.database().reference().child("users").child(userID!).child("Projects").child(projectkey2!).child("Tasks")
        ref2.child(id).setValue(nil)
    }

    
}
