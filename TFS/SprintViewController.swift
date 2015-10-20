//
//  SprintViewController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/17/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
class SprintViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reload();
    }
    
    func reload(){
//        tableView?.reloadData()
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
                let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                
                self.iterations.append(id: id, name: name, path: path, startDate: startDate, endDate: endDate, url: url)
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    tableView?.reloadData()
                })
            }
        }
    }
    
    var iterations:[(id: String, name: String, path: String, startDate: String, endDate: String, url: String)] = []

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.iterations.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        cell!.textLabel?.text = self.iterations[indexPath.row].name
        cell!.detailTextLabel?.text = self.iterations[indexPath.row].startDate + " - " + self.iterations[indexPath.row].startDate
        return cell!
    }
}