//
//  Project.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation

class Project {
    
    var name: String?
    var manager: String?
    var cost: String?
    var id: String?
    
    init(name: String?, manager: String?, id: String?){
        self.name = name
        self.manager = manager
        self.id = id
        
    }
}



