//
//  BackTableViewController.swift
//  TFS
//
//  Created by Giorgio Balconi on 9/6/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class BackTableViewController : UITableViewController {

    // Array for sidebar cells' labels
    var TableCellArray = [String]()
    
    // Populate array with sidebar option labels
    override func viewDidLoad() {
        TableCellArray = ["WORK","SPRINT","TASKS","QUERIES"]
    }
    
    // Returns length of the array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableCellArray.count
    }
    
    // Returns selected cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = TableCellArray[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! ViewController
        
        var indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
        
        destinationViewController.varView = indexPath.row
    }
}