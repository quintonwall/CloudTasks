//
//  NewTaskViewController.swift
//  CloudTasks
//
//  Created by Quinton Wall on 4/24/15.
//  Copyright (c) 2015 salesforce. All rights reserved.
//

import Foundation
import UIKit

class NewTaskViewController: UIViewController, UIBarPositioningDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
     func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
    }
    
}
