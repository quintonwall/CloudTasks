//
//  TaskTableViewCell.swift
//  CloudTasks
//
//  Created by Quinton Wall on 4/21/15.
//  Copyright (c) 2015 salesforce. All rights reserved.
//

import Foundation

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priorityIndicator: UIImageView!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var completedIndicator: UIImageView!
    
    func setPriorityImage(priority: String) {
    
        switch priority {
            case "High":
                self.priorityIndicator?.image = UIImage(named: "high-priority-icon")
            case "Medium":
                self.priorityIndicator?.image = UIImage(named: "")
            default:
                self.priorityIndicator?.image = UIImage(named: "")
            }

    }
    
    func setCompletedImage(status: String) {
    
        switch status {
            case "Completed":
                self.completedIndicator?.image = UIImage(named: "completed-icon")
            default:
                self.completedIndicator?.image = UIImage(named: "")
            }
    }
   
}