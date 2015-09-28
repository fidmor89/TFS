//
//  ProjectsTableViewController.swift
//  TFS
//
//  Created by Giorgio Balconi on 9/27/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class ProjectsTableViewController : UITableViewController {
    
    // Array for sidebar cells' labels
    var items = NSMutableArray()
    
    // Populate array with sidebar option labels
    override func viewDidLoad() {
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        addDummyData()
    }
    
    // Returns length of the array
    func addDummyData() {
        
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "fidmor"
        RestApiManager.sharedInstance.pw = "FIDmor12!"
        
        RestApiManager.sharedInstance.getTeamProjects() { json in
            //            println(json)
            var count: Int = json["count"].int as Int!;                                     //number of objects within json obj
            var jsonOBJ = json["value"]                                                     //get json with projects
            
            for index in 0...(count-1) {                                                    //for each obj in jsonOBJ
                
                let id = jsonOBJ[index]["id"].string as String! ?? ""
                let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                let desc: String = jsonOBJ[index]["description"].string as String! ?? ""
                let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                let state: String = jsonOBJ[index]["state"].string as String! ?? ""
                let revision: Int = jsonOBJ[index]["revision"].int as Int! ?? 0
                
                let teamProject: teamProjects = teamProjects(id: id, name: name, description: desc, url: url, state: state, revision: revision)
                
                self.items.addObject(teamProject)                                           //add to table view model
                dispatch_async(dispatch_get_main_queue(),{                                  //display new data as soon as loaded.
                    tableView?.reloadData()
                })
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProjectCell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "ProjectCell")
        }
        
        let teamProject: teamProjects = self.items[indexPath.row] as! teamProjects              //get
        
        if let nameLabel = cell?.viewWithTag(100) as? UILabel {
            nameLabel.text = teamProject.name
        }
        if let descriptionLabel = cell?.viewWithTag(101) as? UILabel {
            descriptionLabel.text = teamProject.description
        }
        
        return cell!                                                                            //return the cell to be displayed.
    }
}