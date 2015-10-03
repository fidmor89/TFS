//
//  LoginController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLoginButtonTouchDown(sender: AnyObject) {
        
        //Pass parameters to RestApiManager
        RestApiManager.sharedInstance.baseURL = self.serverTextField.text
        RestApiManager.sharedInstance.usr = self.userTextField.text
        RestApiManager.sharedInstance.pw = self.passwordTextField.text
        
        //Test conection
        RestApiManager.sharedInstance.validateAuthorization { auth in
            
            if(auth){
                println("auth ok")
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueToLogin()
                }
            }else{
                println("auth failed")
            }
        }
    }
    
    func performSegueToLogin() -> Void{
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainSplit") as! UISplitViewController
        navigationController?.presentViewController(secondViewController, animated: true, completion: nil)
    }
}

