//
//  CreateProjectViewController.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class CreateProjectViewController: UIViewController {
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var scope: UITextField!
    @IBOutlet weak var manager: UITextField!
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        startDate.minimumDate = NSDate() as Date
        startDate.locale = NSLocale.current
        
        endDate.minimumDate = NSDate() as Date
        endDate.locale = NSLocale.current
    }
    
    @IBAction func createPressed(_ sender: Any) {
        let key = ref.childByAutoId().key
        
        if ((self.name.text?.isEmpty)! || (self.goal.text?.isEmpty)! || ((self.scope.text?.isEmpty)!) || ((self.manager.text?.isEmpty)!) || ((self.author.text?.isEmpty)!))
        {
            let alertController = UIAlertController(title: "Failed to create a project!", message: "Project is not created! Please fill the required information", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
            
        else {
            let startDate1 = self.startDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
            let dateString = dateFormatter.string(from: (startDate1?.date)!)
            print (dateString)
            let endDate1 = self.endDate
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd/MM/yyyy hh:mm a"
            let dateString2 = dateFormatter2.string(from: (endDate1?.date)!)
            print (dateString2)
            
            let project = ["Name" : self.name.text , "Cost" : "0", "Manager" : self.manager.text ,"Scope" : self.scope.text ,"Goal" : self.goal.text,"Author" : self.author.text,"StartDate" : dateString ,"EndDate" : dateString2, "ID" : key] as [String : Any]
            ref.child("users").child(userID!).child("Projects").child(key!).setValue(project)
            
            let alertController = UIAlertController(title: "Created successfully!", message: "Your project has been created successfully", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            self.name.text = ""
            self.goal.text = ""
            self.scope.text = ""
            self.manager.text = ""
            self.author.text = ""
            
        }
        
    }
    
    
}
