//
//  Resource.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import Foundation
class Resource {
    
    var name: String?
    var cost: String?
    var id: String?
    
    
    init(name: String?,cost: String?,id: String?){
        self.name = name
        self.cost = cost
        self.id = id
    }
}
