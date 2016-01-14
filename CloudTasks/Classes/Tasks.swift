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
        
        let sharedInstance = SFRestAPI.sharedInstance()
        let request = sharedInstance.requestForQuery("SELECT Id, Assigned_To__c, Days_Overdue__c, Description__c, Due_Date__c, Priority__c, Status__c, Subject__c FROM CloudTasks__c WHERE Assigned_To__c = '"+SFUserAccountManager.sharedInstance().currentUser.accountIdentity.userId+"' ORDER BY Due_Date__c")
        
        //example of using delegates to separate send logic from handling responses
       
        
        sharedInstance.send(request, delegate: delegate)
        
      /*
        sharedInstance.sendRESTRequest(request,
            failBlock: {error in
                //send back error
            }) { response in
                //todo: send back task
        }
        
      */
        
    }
    
    func updateTaskStatus(id: String, status: String, delegate: SFRestDelegate) {
        
        let sharedInstance = SFRestAPI.sharedInstance()
        let request = sharedInstance.requestForUpdateWithObjectType("CloudTasks__c", objectId: id, fields: ["Status__c" : status])
        
        
        
        sharedInstance.send(request, delegate: delegate)
        
    }
    
}
