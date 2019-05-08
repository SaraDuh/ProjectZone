//
//  ManagerHomepageViewController.swift
//  ProjectManagement
//
//  Created by Aseel Mohimeed on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit
import Firebase

class ManagerHomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

                       navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleSignOutButtonTapped))
        

        // Do any additional setup after loading the view.
    }
    
    @objc func handleSignOutButtonTapped() {
        
        do {
            try Auth.auth().signOut()
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
                (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            
            print ("User logged out")
        } catch let error {
            print ("Failed to logout with error", error)
        }
    }
    

}
