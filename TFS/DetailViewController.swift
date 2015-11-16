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
    @IBOutlet weak var stateImage: UIImageView!
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
    @IBOutlet weak var descriptionWebView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = detailViewState.sharedInstance.index
        
//        let id = detailViewState.sharedInstance.tasks[index]["fields"]["ID"].int as NSNumber?
//        idLabel.text = id
        
        titleLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.Title"].stringValue ?? "None"
        let state = detailViewState.sharedInstance.tasks[index]["fields"]["System.State"].stringValue ?? "None"
        stateLabel.text = state
        
        reasonLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.Reason"].stringValue ?? "None"
        assignedToLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.AssignedTo"].stringValue ?? "None"
        areaPathLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.AreaPath"].stringValue ?? "None"
        
        iterationPathLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.IterationPath"].stringValue ?? "None"

        priorityLabel.text = (detailViewState.sharedInstance.tasks[index]["fields"]["Microsoft.VSTS.Common.Priority"].int as NSNumber?)?.stringValue
        remainingWorkLabel.text = (detailViewState.sharedInstance.tasks[index]["fields"]["Microsoft.VSTS.Scheduling.RemainingWork"].int as NSNumber?)?.stringValue
        
        activityLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["Microsoft.VSTS.Common.Activity"].stringValue ?? "None"
        blockedLabel.text = detailViewState.sharedInstance.tasks[index]["fields"]["System.Blocked"].stringValue ?? "None"
        let html = detailViewState.sharedInstance.tasks[index]["fields"]["System.Description"].stringValue ?? "None"
        
        var url = NSURL(fileURLWithPath: "")
        descriptionWebView.loadHTMLString(html, baseURL: url)

        
        var imagePath: String
        switch state{
        case "Done":
            imagePath = "done.png"
            break
        case "In Progress":
            imagePath = "inProgress.png"
            break
        case "To Do":
            imagePath = "toDo.png"
            break
        case "Removed":
            imagePath = "removed.png"
            break
        case "New":
            imagePath = "new.png"
            break
        default:
            imagePath = "sad.png"
            break
        }
        stateImage.image = UIImage(named: imagePath)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
