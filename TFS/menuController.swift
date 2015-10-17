//
//  menuController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class menuController: UITableViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    var collections:[(id: String, name: String, url: String)] = []
    var teams:[(id: String, name: String, url: String, description: String, identityUrl: String)] = []
    var projects:[(id: String, name: String, description: String, url: String, state: String, revision: String)] = []
    
    override func viewWillDisappear(animated: Bool) {

        if (find(self.navigationController!.viewControllers as! [UIViewController],self)==nil){
            switch viewStateManager.sharedInstance.displayedMenu
            {
            case DisplayedMenu.Collections:
                break;
            case DisplayedMenu.Teams:
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Collections
                break;
            case DisplayedMenu.Projects:
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Teams
                break;
            default:
                break;
            }

        }
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if RestApiManager.sharedInstance.collection == nil
        {
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Collections
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
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
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
        case DisplayedMenu.Teams:
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
        case DisplayedMenu.Projects:
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
            println(viewStateManager.sharedInstance.displayedMenu)
        }
    }
    
    //At menu click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch viewStateManager.sharedInstance.displayedMenu
            
        {
            
        case DisplayedMenu.Collections:
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Teams
            RestApiManager.sharedInstance.collection =  self.collections[indexPath.row].name
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            
            let x = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(x, sender: nil)
            x.detailDescriptionLabel.text = self.collections[indexPath.row].name
            break
            
        case DisplayedMenu.Teams:
            
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Projects
            RestApiManager.sharedInstance.projectId =  self.teams[indexPath.row].id
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            let x = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(x, sender: nil)
            x.detailDescriptionLabel.text = self.teams[indexPath.row].name
            break
            
        case DisplayedMenu.Projects:
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Projects
            RestApiManager.sharedInstance.teamId = self.projects[indexPath.row].id
            
            let DetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(DetailViewController, sender: nil)
            DetailViewController.detailDescriptionLabel.text = self.projects[indexPath.row].name
            
            break
            
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Cuantity of items to display depending on the actual displayed menu
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
            return self.collections.count
        case DisplayedMenu.Teams:
            return self.teams.count
        case DisplayedMenu.Projects:
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
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
            displayedText = self.collections[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break;
        case DisplayedMenu.Teams:
            displayedText = self.teams[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break;
        case DisplayedMenu.Projects:
            displayedText = self.projects[indexPath.row].name
            cell!.accessoryType = UITableViewCellAccessoryType.None
            break;
        default:
            println(viewStateManager.sharedInstance.displayedMenu)
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

class viewStateManager {
    
    var displayedMenu : DisplayedMenu = DisplayedMenu.Collections
    static let sharedInstance = viewStateManager()            //To use manager class as a singleton.

}

enum DisplayedMenu: String {
    case Collections = "Collections"
    case Teams = "Teams"
    case Projects = "Projects"
}