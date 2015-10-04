//
//  menuController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class menuController: UITableViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //cal API and get project collections
//        RestApiManager.sharedInstance.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sign out button event
    @IBAction func signOutButton(sender: AnyObject) {
      
        if (KeychainWrapper.hasValueForKey("credentials")){
                KeychainWrapper.removeObjectForKey("credentials")
        }
        
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! UINavigationController
        navigationController?.presentViewController(loginView, animated: true, completion: nil)
    }
    
}

