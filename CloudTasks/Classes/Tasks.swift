//
//  Tasks.swift
//  CloudTasks
//
//  Created by Quinton Wall on 4/21/15.
//  Copyright (c) 2015 salesforce. All rights reserved.
//

import Foundation

class Tasks: NSObject {
    
    func getTasks(delegate: SFRestDelegate) {
        
        var sharedInstance = SFRestAPI.sharedInstance()
        var request = sharedInstance.requestForQuery("SELECT Id, Assigned_To__c, Days_Overdue__c, Description__c, Due_Date__c, Priority__c, Status__c, Subject__c FROM CloudTasks__c WHERE Assigned_To__c = '"+SFUserAccountManager.sharedInstance().currentUser.accountIdentity.userId+"' ORDER BY Due_Date__c")
        
        sharedInstance.send(request as SFRestRequest, delegate: delegate)
        
    }
    
    func updateTaskStatus(id: String, status: String, delegate: SFRestDelegate) {
        
        let sharedInstance = SFRestAPI.sharedInstance()
        let request = sharedInstance.requestForUpdateWithObjectType("CloudTasks__c", objectId: id, fields: ["Status__c" : status])
        
        
        //todo: change to blocks
        sharedInstance.send(request, delegate: delegate)
        
    }
    
}
