
//
//  ProjectResourcesViewController.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class ProjectResourcesViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var resourcesTable: UITableView!
    
    @IBOutlet weak var totalCost: UILabel!
    
    var taskKey : String?
    var ResourcesReference : DatabaseReference!
    var resourcessList = [Resource]()
    var projectkey3  : String?
    var totalResources = 0.0

    let userID = Auth.auth().currentUser?.uid

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourcessList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! projectResourcesTableViewCell

        let resource: Resource
        resource = resourcessList [indexPath.row]
        cell.name.text = resource.name
        cell.cost.text = resource.cost
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print (taskKey!)
        ResourcesReference = Database.database().reference().child("users").child(userID!).child("Projects").child(projectkey3!).child("Tasks").child(taskKey!)
        //observing the data changes
        ResourcesReference.child("Resources").observe(DataEventType.value, with: { (snapshot) in

            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.resourcessList.removeAll()
                self.totalResources = 0.0
                //iterating through all the values
                for resources in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let taskObject = resources.value as? [String: AnyObject]
                    let name = taskObject?["Name"]
                    let cost = taskObject?["Cost"]
                    if let cost = cost as? String {
                   let Cost = Double(cost)
                   print ("cost string: \(cost as Any)")
                   print ("cost double: \(cost as Any)")
                   self.totalResources = self.totalResources + Cost!
                   self.totalCost.text = "\(self.totalResources) SR"
                  let ref = Database.database().reference()
                let totalCost = ["Total Cost" : self.totalResources]; ref.child("users").child(self.userID!).child("Projects").child(self.projectkey3!).child("Tasks").child(self.taskKey!).child("Total Cost").setValue(totalCost)
                  self.resourcesTable.reloadData()
                                            }
                    let resId = resources.key
                    print (name)
                    print (cost)

                    //creating task object with model and fetched values
                    let resource = Resource (name: name as? String , cost: cost as!String?, id: resId)

                    //appending it to list
                    self.resourcessList.append(resource)
                }

                //reloading the tableview
                self.resourcesTable.reloadData()
            }
        })
        //
        // Do any additional setup after loading the view.

    }

    @IBAction func addPressed(_ sender: Any) {
        let ref = Database.database().reference()
        let key = ref.childByAutoId().key

        if (self.name.text?.isEmpty)! || (self.cost.text?.isEmpty)!
        {
            let alertController = UIAlertController(title: "Failed to add resource!", message: "Resource is not Added! Please fill the required information", preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)

        }

        else {

            let resource = ["Name" : self.name.text , "Cost" : self.cost.text]
            ref.child("users").child(userID!).child("Projects").child(projectkey3!).child("Tasks").child(taskKey!).child("Resources").child(key!).setValue(resource)

            let alertController = UIAlertController(title: "Added successfully!", message: "Your resource has been added successfully to the task", preferredStyle: .alert)

            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            self.name.text = ""
            self.cost.text = ""

        }
    }
    
    //Function to make table view backgound clear
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let res1  = resourcessList[indexPath.row]
        deleteResource(id: res1.id!, index: indexPath.row)
    }
    func deleteResource(id:String, index:Int){
        
        let delref = Database.database().reference().child("users").child(userID!).child("Projects").child(projectkey3!).child("Tasks").child(taskKey!).child("Resources").child(id)
        delref.setValue(nil)
        
        self.resourcesTable.reloadData()
        
        let alertController = UIAlertController(title: "Resource is deleted!", message: "The Resource is successfully deleted!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

