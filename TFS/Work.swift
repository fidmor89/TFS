//
//  Work.swift
//  TFS
//
//  Created by Giorgio Balconi on 9/6/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class Work: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView?
    var items = NSMutableArray()
    
    override func viewDidLoad() {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func viewWillAppear(animated: Bool) {
        let frame:CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100)
        self.tableView = UITableView(frame: frame)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view.addSubview(self.tableView!)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 25, width: self.view.frame.width, height: 50))
        btn.backgroundColor = UIColor.blackColor()
        btn.setTitle("Test RestAPI", forState: UIControlState.Normal)
        btn.addTarget(self, action: "addDummyData", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
    }
    
    func addDummyData() {
        let usr = "fidmor"
        let pw = ""
        RestApiManager.sharedInstance.getTeamProjects (usr, pw:pw) { json in
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        let teamProject: teamProjects = self.items[indexPath.row] as! teamProjects              //get data from model.
        cell!.textLabel?.text = teamProject.name                                                //add some data to the cell
        cell!.detailTextLabel?.text = teamProject.url
        return cell!                                                                            //return the cell to be displayed.
    }
}

