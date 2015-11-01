//
//  TaskDetailViewController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/31/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    //TaskDetailView
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var areaPathLabel: UILabel!
    @IBOutlet weak var iterationPathLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var remainingWorkLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var blockedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
