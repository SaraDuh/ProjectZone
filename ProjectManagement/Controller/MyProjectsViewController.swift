//
//  MyProjectsViewController.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class MyProjectsViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var projectsTable: UITableView!
    var projectsList = [Project]()
    var projectsKeys = [String]()
    var projectsRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myProjectsTableViewCell
        
        let project1: Project
        project1 = projectsList[indexPath.row]
        cell.projectName.text = project1.name
        cell.projectManager.text = project1.manager
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        projectsRef = Database.database().reference().child("users").child(userID!).child("Projects");
        projectsRef.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //clearing the list
                self.projectsList.removeAll()
                
                //iterating through all the values
                for projects in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let projectObject = projects.value as? [String: AnyObject]
                    let projectName = projectObject?["Name"]
                    let projectManager = projectObject?["Manager"]
                    let projectCost = projectObject?["Cost"]
                    let projectId = projects.key
                    
                    self.projectsKeys.append(projectId)
                    
                    //creating artist object with model and fetched values
                    let project = Project(name: projectName as! String?, manager: projectManager as! String?, id: projectId as String?)
                    self.projectsList.append(project)
                }
                
                //reloading the tableview
                self.projectsTable.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pID = storyboard?.instantiateViewController(withIdentifier: "ProjectDetailsViewController") as? ProjectDetailsViewController
        pID?.projectkey = projectsKeys[indexPath.row]
        print (projectsKeys[indexPath.row])
        self.navigationController?.pushViewController(pID!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let projectElement  = projectsList[indexPath.row]
        deleteProjectElement(id: projectElement.id!, index: indexPath.row)
    }
    func deleteProjectElement(id:String, index:Int){
        
        let delref = Database.database().reference().child("users").child(userID!).child("Projects").child(id)
        delref.setValue(nil)
        
        self.projectsTable.reloadData()
        
        let alertController = UIAlertController(title: "Project is deleted!", message: "The project is successfully deleted!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
