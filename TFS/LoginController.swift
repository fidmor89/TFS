//
//  LoginController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class LoginController: UIViewController {
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signedInSwitch: UISwitch!
    
    @IBOutlet weak var caca: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (KeychainWrapper.hasValueForKey("credentials"))
        {
            let credential = KeychainWrapper.stringForKey("credentials")
            self.caca.text = credential
        }
        
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
                
                if (self.signedInSwitch.on)
                {
                    var credentials = "[{"
                    credentials += "\"baseUrl\": \"" + self.serverTextField.text + "\","
                    credentials += "\"user\": \"" + self.userTextField.text + "\","
                    credentials += "\"password\": \"" + self.passwordTextField.text + "\""
                    credentials += "}]"
                    KeychainWrapper.setString(credentials,forKey:"credentials")
                }
                
                
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

