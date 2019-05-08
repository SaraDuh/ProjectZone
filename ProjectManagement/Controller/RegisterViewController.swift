//
//  RegisterViewController.swift
//  ProjectManagement
//
//  Created by Aseel Mohimeed on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func registedClicked(_ sender: Any) {
        let fName = self.fName.text
        let lName = self.lName.text
        let email = self.email.text
        let password = self.password.text
        let ref = Database.database().reference().root
        
        
        if email != "" && password != "" && fName != "" && lName != ""{
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in if error != nil{
                print(error!)
                
                let alertController = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                //success
                print ("Registration Successful!")
                let userID = Auth.auth().currentUser!.uid
                
                ref.child("users").child(userID).setValue(["First Name": fName, "Last Name": lName, "Email": email])
                
                
                self.fName.text = ""
                self.lName.text = ""
                self.email.text = ""
                self.password.text = ""
                

                self.performSegue(withIdentifier: "goToHomepage", sender: self)
                }
            })
        } else {
            self.view.endEditing(true)
            
            let alert = UIAlertController(
                title: "Invalid Registration!",
                message: "Please fill in all fields",
                preferredStyle: UIAlertController.Style.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // do something when user press OK button, like deleting text in both fields or do nothing
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }

    }
    
    
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
