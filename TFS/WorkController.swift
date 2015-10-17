//
//  WorkController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import UIKit

class WorkController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var iterations:[(id: String, name: String, path: String, startDate: String, endDate: String, url: String)] = []
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        //        self.detailDescriptionLabel.text = self.detailItem as  ?? ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onNavigateButtonTouchDown(sender: AnyObject) {
        
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
            break;
        case DisplayedMenu.Teams:
            break;
        case DisplayedMenu.Projects:
            
            let x = self.storyboard!.instantiateViewControllerWithIdentifier("SprintView") as! SprintViewController
            self.splitViewController?.showDetailViewController(x, sender: nil)
            
            break;
        default:
            break;
        }
    }
    
}
