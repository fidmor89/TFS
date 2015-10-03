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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonTouchDown(sender: AnyObject) {
        
        //Pass parameters to RestApiManager
        RestApiManager.sharedInstance.baseURL = self.serverTextField.text
        RestApiManager.sharedInstance.usr = self.userTextField.text
        RestApiManager.sharedInstance.pw = self.passwordTextField.text
        
        //Test conection
        RestApiManager.sharedInstance.validateAuthorization { auth in
            
            if(auth){
                //make segue
                println("logged")
            }else{
                //let the user know there was a problem in auth.
                println("failed auth: \(auth)")
            }
        }
    }
}

