//
//  AppDelegate.swift
//  CloudTasks
//
//  Created by Quinton Wall on 4/15/15.
//  Copyright (c) 2015 salesforce. All rights reserved.
//

import Foundation
import UIKit

// Fill these in when creating a new Connected Application on Force.com
let RemoteAccessConsumerKey = "3MVG9fMtCkV6eLhdjZ8TO0bd8hGzu5J5yQgUxxSuCecbgoXyi.K29XllYaR_X0S5uGpH_kLhPbR2bMOys1U2D";
let OAuthRedirectURI        = "mobilesdk://success";
let scopes = ["api"];

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    override
    init()
    {
        super.init()
        SFLogger.setLogLevel(SFLogLevelDebug)
        
        SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
        SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
        SalesforceSDKManager.sharedManager().authScopes = scopes
        SalesforceSDKManager.sharedManager().postLaunchAction = {
            [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            self.log(SFLogLevelInfo, msg:"Post-launch: launch actions taken: \(launchActionString)");
            self.setupRootViewController();
        }
        SalesforceSDKManager.sharedManager().launchErrorAction = {
            [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
            if let actualError = error {
                self.log(SFLogLevelError, msg:"Error during SDK launch: \(actualError.localizedDescription)")
            } else {
                self.log(SFLogLevelError, msg:"Unknown error during SDK launch.")
            }
            self.initializeAppViewState()
            SalesforceSDKManager.sharedManager().launch()
        }
        SalesforceSDKManager.sharedManager().postLogoutAction = {
            [unowned self] in
            self.handleSdkManagerLogout()
        }
        SalesforceSDKManager.sharedManager().switchUserAction = {
            [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }
    }
    
    // MARK: - App delegate lifecycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.initializeAppViewState();
        
        //
        // If you wish to register for push notifications, uncomment the line below.  Note that,
        // if you want to receive push notifications from Salesforce, you will also need to
        // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
        //
        // SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
        
        SalesforceSDKManager.sharedManager().launch()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        //
        // Uncomment the code below to register your device token with the push notification manager
        //
        //
        // SFPushNotificationManager.sharedInstance().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
        // if (SFAccountManager.sharedInstance().credentials.accessToken != nil)
        // {
        //    SFPushNotificationManager.sharedInstance().registerForSalesforceNotifications()
        // }
    }
    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        // Respond to any push notification registration errors here.
    }

    // MARK: - Private methods
    func initializeAppViewState()
    {
        setupRootViewController()
        self.window!.makeKeyAndVisible()
    }
    
    func setupRootViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier("HomeView")
        self.window!.rootViewController = mainController as? UIViewController
    }
    
    func resetViewState(postResetBlock: () -> ())
    {
        if let rootViewController = self.window!.rootViewController {
            if let presentedViewController = rootViewController.presentedViewController {
                rootViewController.dismissViewControllerAnimated(false, completion: postResetBlock)
                return
            }
        }
        
        postResetBlock()
    }
    
    func handleSdkManagerLogout()
    {
        self.log(SFLogLevelDebug, msg: "SFAuthenticationManager logged out.  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            
            // Multi-user pattern:
            // - If there are two or more existing accounts after logout, let the user choose the account
            //   to switch to.
            // - If there is one existing account, automatically switch to that account.
            // - If there are no further authenticated accounts, present the login screen.
            //
            // Alternatively, you could just go straight to re-initializing your app state, if you know
            // your app does not support multiple accounts.  The logic below will work either way.
            
            var numberOfAccounts : Int;
            let allAccounts = SFUserAccountManager.sharedInstance().allUserAccounts as! [SFUserAccount]?
            if allAccounts != nil {
                numberOfAccounts = allAccounts!.count;
            } else {
                numberOfAccounts = 0;
            }
            
            if numberOfAccounts > 1 {
                let userSwitchVc = SFDefaultUserManagementViewController(completionBlock: {
                    action in
                    self.window!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
                })
                self.window!.rootViewController!.presentViewController(userSwitchVc, animated: true, completion: nil)
            } else {
                if (numberOfAccounts == 1) {
                    SFUserAccountManager.sharedInstance().currentUser = allAccounts![0]
                }
                SalesforceSDKManager.sharedManager().launch()
            }
        }
    }
    
    func handleUserSwitch(fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        let fromUserName = (fromUser != nil) ? fromUser?.userName : "<none>"
        let toUserName = (toUser != nil) ? toUser?.userName : "<none>"
        self.log(SFLogLevelDebug, msg:"SFUserAccountManager changed from user \(fromUserName) to \(toUserName).  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            SalesforceSDKManager.sharedManager().launch()
        }
    }
}