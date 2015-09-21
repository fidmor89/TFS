//
//  Tasks.swift
//  TFS
//
//  Created by Giorgio Balconi on 9/6/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class Tasks: UIViewController {
    
    //var faicon =
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}