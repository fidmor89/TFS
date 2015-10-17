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
    
    var iterations:[(id: String, name: String, path: String, startDate: String, endDate: String)] = []
    
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
            self.iterations = []
            RestApiManager.sharedInstance.getIterationsByTeamAndProject { json in
                var count: Int = json["count"].int as Int!;         //number of objects within json obj
                var jsonOBJ = json["value"]                         //get json with projects
                
                for index in 0...(count-1) {                        //for each obj in jsonOBJ
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let path: String = jsonOBJ[index]["path"].string as String! ?? ""
                    let startDate: String = jsonOBJ[index]["attributes"]["startDate"].string as String! ?? ""
                    let endDate: String = jsonOBJ[index]["attributes"]["finishDate"].string as String! ?? ""
                    
                    self.iterations.append(id: id, name: name, path: path, startDate: startDate, endDate: endDate)
                    
                    //call dispatcher to update view
                }
            }
            
            break;
        default:
            break;
        }
    }
    
}
