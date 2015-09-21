//
//  Work.swift
//  TFS
//
//  Created by Giorgio Balconi on 9/6/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class Work: UIViewController {
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.table1.rowHeight = UITableViewAutomaticDimension
        
        self.table1.estimatedRowHeight = 44.0
    }

    @IBOutlet var table1: UITableView!
    


    
}