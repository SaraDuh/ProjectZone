//
//  Task.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Task {
    
    var name: String?
    var assignedMember: String?
    var id: String?

    
    init(name: String?,assignedMember: String?,id: String?){
        self.name = name
        self.assignedMember = assignedMember
        self.id = id
    }
}
