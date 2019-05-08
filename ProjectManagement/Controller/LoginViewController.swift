//
//  LoginViewController.swift
//  ProjectManagement
//
//  Created by Aseel Mohimeed on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {


    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error != nil {
                print (error!)
                
                self.view.endEditing(true)
                
                if (self.email.text?.isEmpty)! || (self.password.text?.isEmpty)!
                {
                    let alert = UIAlertController(
                        title: "Invalid Login!",
                        message: "Please fill your e-mail and password",
                        preferredStyle: UIAlertController.Style.alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        // do something when user press OK button, like deleting text in both fields or do nothing
                    }
                    
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                    
                else {
                    // need to add handel exception when invalid email or password
                    //MBProgressHUD.dismiss()
                    print("error")
                    let alertController = UIAlertController(title: "Invalid Login!", message: "Incorrect credentials", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    print(error?.localizedDescription as Any)
                }
                
            } else {
                
                self.performSegue(withIdentifier: "goToHomepage", sender: self)}
            
        }

    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
