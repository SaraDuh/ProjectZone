//
//  myProjectsTableViewCell.swift
//  ProjectManagement
//
//  Created by Deema on 21/07/1440 AH.
//  Copyright © 1440 Aseel Mohimeed. All rights reserved.
//

import UIKit

class myProjectsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var projectManager: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
