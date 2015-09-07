//
//  ViewController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 9/5/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // View controls
    @IBOutlet weak var Open: UIBarButtonItem!// Button that opens the sidebar
    @IBOutlet weak var label: UILabel!// var that shows the sidebar items work
    
    // Other variables
    var varView = Int()// basically useless
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Toggles the sidebar
        Open.target = self.revealViewController()
        Open.action = Selector("revealToggle:")
        
        println("Startin tests")
        let api: APIWrapper = APIWrapper();
        api.getTeamProjects("almlatam", usr: "fidmor", pw: "FIDmor12!")

        
        // Change label text according to the value
        if(varView == 0){
            label.text = "first"
        }
        else {
            label.text = "others"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

