//
//  Taylor.swift
//  CloudTasks
//
//  Created by Quinton Wall on 4/15/15.
//  Copyright (c) 2015 salesforce. All rights reserved.
//

import Foundation
import UIKit

class RootViewController : UITableViewController, SFRestDelegate
{
    var tasksModel = Tasks()
    var dataRows = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tasksModel.getTasks(self)
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.dataRows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as! TaskTableViewCell
        
        var obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
        
        // Configure the cell...
        cell.setPriorityImage((obj.objectForKey("Priority__c") as? String)!)
        cell.setCompletedImage((obj.objectForKey("Status__c") as? String)!)
        cell.subject?.text = obj.objectForKey("Subject__c") as? String
        cell.dueDate?.text = obj.objectForKey("Due_Date__c") as? String
        cell.desc?.text = obj.objectForKey("Description__c") as? String
        
        return cell
    }
    
    
    
    
    // MARK: SFRestDelegate events.
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        var records = jsonResponse.objectForKey("records") as! NSArray
        println("request: Tasks: #records: \(records.count)");
        self.dataRows = records
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func request(request: SFRestRequest?, didFailLoadWithError error:NSError) {
        println("In Error: \(error)")
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        println("In requestDidCancelLoad \(request)")
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        println("In requestDidTimeout \(request)")
    }


}