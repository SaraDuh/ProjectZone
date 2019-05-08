//
//  ProjectDetailsViewController.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class ProjectDetailsViewController: UIViewController {
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Goal: UILabel!
    @IBOutlet weak var scope: UILabel!
    @IBOutlet weak var Manager: UILabel!
    @IBOutlet weak var Author: UILabel!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    var projectkey : String?
    let userID = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference().child("users").child(userID!).child("Projects").child(self.projectkey!);
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let projectObject = snapshot.value as? [String: AnyObject]
            // let projectNum  = self.projectkey
            let pname  = projectObject?["Name"]
            let pgoal  = projectObject?["Goal"]
            let pscope  = projectObject?["Scope"]
            let pmanager  = projectObject?["Manager"]
            let pauthor  = projectObject?["Author"]
            let psdate  = projectObject?["StartDate"]
            let pedate  = projectObject?["EndDate"]
            
            //appending it to list
            self.Name.text = pname as? String
            self.Goal.text = pgoal as? String
            self.scope.text = pscope as? String
            self.Manager.text = pmanager as? String
            self.Author.text = pauthor as? String
            self.StartDate.text = psdate as? String
            self.EndDate.text = pedate as? String
            
        })
    }
    
    @IBAction func taskspressed(_ sender: Any) {
        let pID = storyboard?.instantiateViewController(withIdentifier: "ProjectTasksViewController") as? ProjectTasksViewController
        pID?.projectkey2 = self.projectkey!
        print (self.projectkey!)
        self.navigationController?.pushViewController(pID!, animated: true)
    }
    
}
