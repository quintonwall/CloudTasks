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
     var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    let darkBrown = UIColor(red:0.50, green:0.36, blue:0.08, alpha:1.0)
    let midBrown = UIColor(red:0.83, green:0.69, blue:0.42, alpha:1.0)
    let lightBrown = UIColor(red:1.00, green:0.89, blue:0.67, alpha:1.0)
    
    //@IBOutlet weak var newTaskButton: UIBarButtonItem!
    
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = darkBrown
        refreshControl?.attributedTitle = NSAttributedString(string: "hi ho. hi ho. more tasks we go.")
        refreshControl?.addTarget(self, action: "getTasks", forControlEvents:UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getTasks()
    }
    
    
  
    
    func getTasks() {
         tasksModel.getTasks(self)
        
        if self.spinner.isAnimating() {
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.stopAnimating()
            })
        }
        
        // Hide the refresh control
        self.refreshControl?.endRefreshing()
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
     }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.dataRows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as! TaskTableViewCell
        
        let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
        
        // Configure the cell...
        cell.setPriorityImage((obj.objectForKey("Priority__c") as? String)!)
        cell.setCompletedImage((obj.objectForKey("Status__c") as? String)!)
        cell.subject?.text = obj.objectForKey("Subject__c") as? String
        cell.dueDate?.text = obj.objectForKey("Due_Date__c") as? String
        cell.desc?.text = obj.objectForKey("Description__c") as? String
        
        return cell
    }
    
    
    
    
    // MARK: SFRestDelegate events.
    
    //TODO: Change to blocks.
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        
        
        if Int((request?.method.rawValue)!) == 5 {
            print("request:didLoadResponse: task update successful")
            tasksModel.getTasks(self) //bit chatty, but ok for now
        }
        else {
            let records = jsonResponse.objectForKey("records") as! NSArray
            print("request:didLoadResponse: #records: \(records.count)");
            self.dataRows = records
            
            
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })

    }
    
    func request(request: SFRestRequest?, didFailLoadWithError error:NSError) {
        print("In Error: \(error)")
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        print("In requestDidCancelLoad \(request)")
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        print("In requestDidTimeout \(request)")
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            //TODO: add call to delete task in Model
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:
        NSIndexPath) {
    }
    
    
 
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        /*
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete",  handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                    //TODO: add delete to model
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        */
            let completeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Complete",  handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                    let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                    let id = obj.objectForKey("Id") as? String
                    self.tasksModel.updateTaskStatus(id!, status: "Completed", delegate: self)
                    self.tableView.reloadData()
            })
        completeAction.backgroundColor = darkBrown
        
        
            let changeStatusAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Change Status", handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        
                // Create an option menu as an action sheet
                let optionMenu = UIAlertController(title: nil, message: "Change Status?", preferredStyle: .ActionSheet)
        
                // Add actions to the menu
                let nsAction = UIAlertAction(title: "Not Started", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction!) -> Void in
                    
                    let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                    let id = obj.objectForKey("Id") as? String
                    self.tasksModel.updateTaskStatus(id!, status: "Not Started", delegate: self)
                     self.tableView.reloadData()
                })
              
               
                let ipAction = UIAlertAction(title: "In Progress", style: UIAlertActionStyle.Default, handler: {
                        (action:UIAlertAction!) -> Void in
                        
                        let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                        let id = obj.objectForKey("Id") as? String
                        self.tasksModel.updateTaskStatus(id!, status: "In Progress", delegate: self)
                         self.tableView.reloadData()
                })
              
              
                let compAction = UIAlertAction(title: "Complete", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction!) -> Void in
                    
                    let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                    let id = obj.objectForKey("Id") as? String
                    self.tasksModel.updateTaskStatus(id!, status: "Completed", delegate: self)
                    self.tableView.reloadData()
                })
                
                
                let defAction = UIAlertAction(title: "Deferred", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction!) -> Void in
                    
                    let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                    let id = obj.objectForKey("Id") as? String
                    self.tasksModel.updateTaskStatus(id!, status: "Deferred", delegate: self)
                     self.tableView.reloadData()
                })
               
              
                let wAction = UIAlertAction(title: "Waiting", style: UIAlertActionStyle.Default, handler: {
                        (action:UIAlertAction!) -> Void in
                        
                        let obj : AnyObject! =  self.dataRows.objectAtIndex(indexPath.row)
                        let id = obj.objectForKey("Id") as? String
                        self.tasksModel.updateTaskStatus(id!, status: "Waiting", delegate: self)
                        self.tableView.reloadData()
                        })
               
                
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel,handler: nil)
               
                
            optionMenu.addAction(nsAction)
            optionMenu.addAction(ipAction)
            optionMenu.addAction(compAction)
            optionMenu.addAction(defAction)
            optionMenu.addAction(wAction)
            optionMenu.addAction(cancelAction)
        
            // Display the menu
            self.presentViewController(optionMenu, animated: true, completion: nil)
            }
        )
        changeStatusAction.backgroundColor = midBrown
            
        return [completeAction, changeStatusAction]
    }

}