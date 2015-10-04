//
//  menuController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class menuController: UITableViewController {

    var collections:[(id: String, name: String, url: String)] = []

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //cal API and get project collections
        RestApiManager.sharedInstance.getCollections { json in
            var count: Int = json["count"].int as Int!;         //number of objects within json obj
            var jsonOBJ = json["value"]                         //get json with projects
            
            for index in 0...(count-1) {                                                    //for each obj in jsonOBJ
                
                let id = jsonOBJ[index]["id"].string as String! ?? ""
                let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                
                let item: (String, String, String) = (id, name, url)
                self.collections.append(id: id, name: name, url: url)
                
                dispatch_async(dispatch_get_main_queue(), {
                    tableView?.reloadData()})
            }
//            println(self.collections)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        cell!.textLabel?.text = self.collections[indexPath.row].name

        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sign out button event
    @IBAction func signOutButton(sender: AnyObject) {
      
        if (KeychainWrapper.hasValueForKey("credentials")){
                KeychainWrapper.removeObjectForKey("credentials")
        }
        
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! UINavigationController
        navigationController?.presentViewController(loginView, animated: true, completion: nil)
    }
    
}

