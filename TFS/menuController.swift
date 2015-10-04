//
//  menuController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class menuController: UITableViewController {
    
    var displayedMenu : String = "";
    var collections:[(id: String, name: String, url: String)] = []
    var teams:[(id: String, name: String, url: String, description: String, identityUrl: String)] = []
    var projects:[(id: String, name: String, description: String, url: String, state: String, revision: String)] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if RestApiManager.sharedInstance.collection == nil
        {
            displayedMenu = "Collections"
        }
        self.populateMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateMenu(){
        switch self.displayedMenu
        {
        case "Collections":
            self.collections = []
            RestApiManager.sharedInstance.getCollections { json in
                var count: Int = json["count"].int as Int!;         //number of objects within json obj
                var jsonOBJ = json["value"]                         //get json with projects
                
                for index in 0...(count-1) {                        //for each obj in jsonOBJ
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    
                    self.collections.append(id: id, name: name, url: url)
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()})
                }
            }
        case "Teams":
            self.teams = []
            RestApiManager.sharedInstance.getTeams { json in
                var count: Int = json["count"].int as Int!;         //number of objects within json obj
                var jsonOBJ = json["value"]                         //get json with projects
                
                for index in 0...(count-1) {                        //for each obj in jsonOBJ
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    let description: String = jsonOBJ[index]["description"].string as String! ?? ""
                    let identityUrl: String = jsonOBJ[index]["identityUrl"].string as String! ?? ""
                    
                    self.teams.append(id: id, name: name, url: url, description: description, identityUrl: identityUrl)
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()})
                }
            }
        case "Projects":
            self.projects = []
            RestApiManager.sharedInstance.getProjects { json in
                var count: Int = json["count"].int as Int!;         //number of objects within json obj
                var jsonOBJ = json["value"]                         //get json with projects
                
                for index in 0...(count-1) {                        //for each obj in jsonOBJ
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let description: String = jsonOBJ[index]["description"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    let state: String = jsonOBJ[index]["state"].string as String! ?? ""
                    let revision: String = jsonOBJ[index]["revision"].string as String! ?? ""
                    
                    self.projects.append(id: id, name: name, description: description, url: url, state: state, revision: revision)
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()})
                }
            }
        default:
            println(self.displayedMenu)
        }
    }
    
    //At menu click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch self.displayedMenu
        {
        case "Collections":
            self.displayedMenu = "Teams"
            RestApiManager.sharedInstance.collection =  self.collections[indexPath.row].name
            break
        case "Teams":
            self.displayedMenu = "Projects"
            RestApiManager.sharedInstance.projectId =  self.teams[indexPath.row].id
            break
        case "Projects":
            //Update detail view.
            break
        default:
            break
        }
        
        self.populateMenu()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Cuantity of items to display depending on the actual displayed menu
        switch self.displayedMenu
        {
        case "Collections":
            return self.collections.count
        case "Teams":
            return self.teams.count
        case "Projects":
            return self.projects.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL")
        }
        
        var displayedText: String = ""
        switch self.displayedMenu
        {
        case "Collections":
            displayedText = self.collections[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.DetailButton
            break;
        case "Teams":
            displayedText = self.teams[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.DetailButton
            break;
        case "Projects":
            displayedText = self.projects[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            break;
        default:
            println(self.displayedMenu)
        }
        
        cell!.textLabel?.text = displayedText
        return cell!
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

