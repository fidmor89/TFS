//
//  menuController.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/3/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import MBProgressHUD

class menuController: UITableViewController {
    
    var collections:[(id: String, name: String, url: String)] = []
    var teams:[(id: String, name: String, url: String, description: String, identityUrl: String)] = []
    var projects:[(id: String, name: String, description: String, url: String, state: String, revision: String)] = []
    var work:[String] = ["Epic", "Feature", "PBI's", "Past", "Current", "Future"]
    var iterations:[(id: String, name: String, path: String, startDate: String, endDate: String, url: String)] = []
    var tasks:[(id: String, url: String)] = []
    
    var workColor:[UIColor] = [ UIColor.orangeColor(),
        UIColor.purpleColor(),
        UIColor.blueColor(),
        UIColor(red: 0, green: 0, blue: 0, alpha: 0),
        UIColor(red: 0, green: 0, blue: 0, alpha: 0),
        UIColor(red: 0, green: 0, blue: 0, alpha: 0)]
    
    
    
    override func viewWillDisappear(animated: Bool) {
        
        if (find(self.navigationController!.viewControllers as! [UIViewController],self)==nil){
            switch viewStateManager.sharedInstance.displayedMenu{
            case DisplayedMenu.Collections:
                break
            case DisplayedMenu.Projects:
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Collections
                RestApiManager.sharedInstance.projectId = nil
                break
            case DisplayedMenu.Teams:
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Projects
                RestApiManager.sharedInstance.teamId = ""
                break
            case DisplayedMenu.Work:
                //                RestApiManager.sharedInstance.initialize()  //Back button reloads to select user collection
                if RestApiManager.sharedInstance.teamId == ""
                {
                    viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Projects
                }else{
                    viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Teams
                }
                
                break
            case DisplayedMenu.Tasks:
                viewStateManager.sharedInstance.displayedMenu = viewStateManager.sharedInstance.previousMenu!
                break
                //            case DisplayedMenu.Sprints:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.Epic:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.Feature:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.PBI:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.Past:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.Current:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
                //            case DisplayedMenu.Future:
                //                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                //                break
            default:
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
                break
            }
            
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        
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
                var count: Int = json["count"].int as Int!         //number of objects within json obj
                var jsonOBJ = json["value"]                         //get json with projects
                
                for index in 0...(count-1) {                        //for each obj in jsonOBJ
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    
                    self.collections.append(id: id, name: name, url: url)
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()})
                }
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
                
            }
            break
            
        case DisplayedMenu.Projects:
            self.teams = []
            RestApiManager.sharedInstance.getTeams { json in
                var count: Int = json["count"].int as Int!         //number of objects within json obj
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
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
                
            }
            break
            
        case DisplayedMenu.Teams:
            self.projects = []
            RestApiManager.sharedInstance.getProjects { json in
                var count: Int = json["count"].int as Int!         //number of objects within json obj
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
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
                
            }
            break
            
            
        case DisplayedMenu.Epic:
            
            RestApiManager.sharedInstance.getEpics() { json in
                
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
            }
            
            
            break
        case DisplayedMenu.Feature:
            RestApiManager.sharedInstance.getFeatures() { json in
                
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
            }
            break
        case DisplayedMenu.PBI:
            RestApiManager.sharedInstance.getPBI() { json in
                
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
            }
            
            break
        case DisplayedMenu.Past:
            
            self.iterations = []
            RestApiManager.sharedInstance.getIterationsByTeamAndProject { json in
                var count: Int = json["count"].int as Int!         //number of objects within json obj
                var jsonOBJ = json["value"]
                
                for index in 0...(count-1) {
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let path: String = jsonOBJ[index]["path"].string as String! ?? ""
                    let startDate: String = jsonOBJ[index]["attributes"]["startDate"].string as String! ?? ""
                    let endDate: String = jsonOBJ[index]["attributes"]["finishDate"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    
                    if(endDate != ""){
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        let dateEnd = dateFormatter.dateFromString(endDate)
                        let dateNow = NSDate()
                        //adding only sprints that has finished
                        if dateEnd!.compare(dateNow) == NSComparisonResult.OrderedAscending
                        {
                            dateFormatter.dateFormat = "MMM dd,YY"
                            
                            self.iterations.append(id: id, name: name, path: path, startDate: dateFormatter.stringFromDate(dateNow), endDate: dateFormatter.stringFromDate(dateEnd!), url: url)
                            dispatch_async(dispatch_get_main_queue(), {
                                tableView?.reloadData()
                            })
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
            }
            
            break
            
            
        case DisplayedMenu.Current:
            
            self.iterations = []
            RestApiManager.sharedInstance.getCurrentSprint { json in
                var count: Int = json["count"].int as Int!         //number of objects within json obj
                var jsonOBJ = json["value"]
                
                for index in 0...(count-1) {
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let path: String = jsonOBJ[index]["path"].string as String! ?? ""
                    let startDate: String = jsonOBJ[index]["attributes"]["startDate"].string as String! ?? ""
                    let endDate: String = jsonOBJ[index]["attributes"]["finishDate"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    let dateStart = dateFormatter.dateFromString(startDate)
                    let dateEnd = dateFormatter.dateFromString(endDate)
                    
                    dateFormatter.dateFormat = "MMM dd,YY"
                    
                    self.iterations.append(id: id, name: name, path: path, startDate: dateFormatter.stringFromDate(dateStart!), endDate: dateFormatter.stringFromDate(dateEnd!), url: url)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()
                    })
                }
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
                
            }
            
            break
        case DisplayedMenu.Future:
            self.iterations = []
            RestApiManager.sharedInstance.getIterationsByTeamAndProject { json in
                var count: Int = json["count"].int as Int!         //number of objects within json obj
                var jsonOBJ = json["value"]
                
                for index in 0...(count-1) {
                    
                    let id = jsonOBJ[index]["id"].string as String! ?? ""
                    let name: String = jsonOBJ[index]["name"].string as String! ?? ""
                    let path: String = jsonOBJ[index]["path"].string as String! ?? ""
                    let startDate: String = jsonOBJ[index]["attributes"]["startDate"].string as String! ?? ""
                    let endDate: String = jsonOBJ[index]["attributes"]["finishDate"].string as String! ?? ""
                    let url: String = jsonOBJ[index]["url"].string as String! ?? ""
                    
                    if(startDate != ""){
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                        let dateStart = dateFormatter.dateFromString(startDate)
                        let dateEnd = dateFormatter.dateFromString(endDate)
                        let dateNow = NSDate()
                        //adding only sprints that has not started
                        if dateStart!.compare(dateNow) == NSComparisonResult.OrderedDescending
                        {
                            dateFormatter.dateFormat = "MMM dd,YY"
                            self.iterations.append(id: id, name: name, path: path, startDate: dateFormatter.stringFromDate(dateStart!), endDate: dateFormatter.stringFromDate(dateEnd!), url: url)
                        }
                        
                    }else{
                        //Display iterations with no date as future iterations
                        self.iterations.append(id: id, name: name, path: path, startDate: startDate, endDate: endDate, url: url)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        tableView?.reloadData()
                    })
                }
                dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                })
                
            }
            
            break
            
        case DisplayedMenu.Tasks:
            self.tasks = []
            RestApiManager.sharedInstance.getTaks() { json in
                
                var jsonOBJ = json["workItems"]

                
                for i in 0...25 {

                    let id = jsonOBJ[i]["id"].string as String! ?? ""
                    let url = jsonOBJ[i]["url"].string as String! ?? ""

                    println(NSString(format: "ID: %@  - URL:%@", id, url))
                    
                }
            }
            break
            
        default:
            println(viewStateManager.sharedInstance.displayedMenu.rawValue)
            dispatch_async(dispatch_get_main_queue(), {
                tableView?.reloadData()
            })
            dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            })
            
            break
        }
        
        //        dispatch_async(dispatch_get_main_queue(), {                                         //run in the main GUI thread
        //            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        //        })
        
    }
    
    //At detail Click
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        switch viewStateManager.sharedInstance.displayedMenu{
        case DisplayedMenu.Teams:
            
            RestApiManager.sharedInstance.teamId = self.projects[indexPath.row].name
            
            break
        case DisplayedMenu.Projects:
            
            RestApiManager.sharedInstance.projectId =  self.teams[indexPath.row].name
            
            break
        default:
            break
        }
        viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Work
        let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    //At menu click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch viewStateManager.sharedInstance.displayedMenu{
            
        case DisplayedMenu.Collections:
            if self.collections.count == 0{
                break
            }
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Projects
            RestApiManager.sharedInstance.collection =  self.collections[indexPath.row].name
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            
            let x = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(x, sender: nil)
            x.detailDescriptionLabel.text = self.collections[indexPath.row].name
            break
            
        case DisplayedMenu.Teams:
            if self.projects.count == 0{
                break
            }
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Teams
            RestApiManager.sharedInstance.teamId = self.projects[indexPath.row].name
            
            let DetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(DetailViewController, sender: nil)
            DetailViewController.detailDescriptionLabel.text = self.projects[indexPath.row].name
            break
            
        case DisplayedMenu.Projects:
            if self.teams.count == 0{
                break
            }
            viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Teams
            RestApiManager.sharedInstance.projectId =  self.teams[indexPath.row].name
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            let x = self.storyboard!.instantiateViewControllerWithIdentifier("WorkView") as! WorkController
            self.splitViewController?.showDetailViewController(x, sender: nil)
            x.detailDescriptionLabel.text = self.teams[indexPath.row].name
            break
            
        case DisplayedMenu.Work:
            if self.work.count == 0{
                break
            }
            switch self.work[indexPath.row + (indexPath.section * 3)]{
            case "Epic":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Epic
                break
            case "Feature":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Feature
                break
            case "PBI's":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.PBI
                break
            case "Past":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Past
                break
            case "Current":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Current
                break
            case "Future":
                viewStateManager.sharedInstance.displayedMenu = DisplayedMenu.Future
                break
            default:
                println(self.work[indexPath.row + (indexPath.section * 3)])
                break
            }
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            break
            
            
        case DisplayedMenu.Epic:
            break
            
        case DisplayedMenu.Feature:
            break
            
        case DisplayedMenu.PBI:
            break
            
        case DisplayedMenu.Past:
            viewStateManager.sharedInstance.savePrevious(DisplayedMenu.Tasks)
            RestApiManager.sharedInstance.iterationPath = self.iterations[indexPath.row].path
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            break
            
        case DisplayedMenu.Current:
            viewStateManager.sharedInstance.savePrevious(DisplayedMenu.Tasks)
            RestApiManager.sharedInstance.iterationPath = self.iterations[indexPath.row].path
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            break
            
        case DisplayedMenu.Future:
            viewStateManager.sharedInstance.savePrevious(DisplayedMenu.Tasks)
            RestApiManager.sharedInstance.iterationPath = self.iterations[indexPath.row].path
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("menuView") as! menuController
            navigationController?.pushViewController(secondViewController, animated: true)
            break
            
        default:
            println(viewStateManager.sharedInstance.displayedMenu.rawValue)
            break
        }
    }
    
    //Number of cells
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Cuantity of items to display depending on the actual displayed menu
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
            return self.collections.count
        case DisplayedMenu.Projects:
            return self.teams.count
        case DisplayedMenu.Teams:
            return self.projects.count
        case DisplayedMenu.Work:
            return self.work.count/2
            
            //        case DisplayedMenu.Epic:
            //            break
            //        case DisplayedMenu.Feature:
            //            break
            //        case DisplayedMenu.PBI:
            //            break
            
        case DisplayedMenu.Past:
            return  self.iterations.count
        case DisplayedMenu.Current:
            return  self.iterations.count
        case DisplayedMenu.Future:
            return  self.iterations.count
        default:
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if viewStateManager.sharedInstance.displayedMenu == DisplayedMenu.Work{
            if section == 0{
                return "Backlogs"
            }else{
                return "Sprints"
            }
            
        }
        return nil
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if viewStateManager.sharedInstance.displayedMenu == DisplayedMenu.Work{
            return 2
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if viewStateManager.sharedInstance.displayedMenu == DisplayedMenu.Work{
            return 40
        }
        return 0
    }
    
    //Build cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("WorkItemCell") as? WorkItemCellModel
        if cell == nil{
            cell = WorkItemCellModel(style: UITableViewCellStyle.Value1, reuseIdentifier: "WorkItemCell")
        }
        
        var titleText: String = ""
        var detailText: String = ""
        var imagePath: String = ""
        switch viewStateManager.sharedInstance.displayedMenu
        {
        case DisplayedMenu.Collections:
            titleText = self.collections[indexPath.row].name
            detailText = ""
            imagePath = ""
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break
            
        case DisplayedMenu.Projects:
            titleText = self.teams[indexPath.row].name
            detailText = self.teams[indexPath.row].description
            imagePath = "collectionIcon.png"
            cell!.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            break
            
        case DisplayedMenu.Teams:
            titleText = self.projects[indexPath.row].name
            detailText = self.projects[indexPath.row].description
            imagePath = "projectIcon.png"
            cell!.accessoryType = UITableViewCellAccessoryType.DetailButton
            break
            
        case DisplayedMenu.Work:
            cell = tableView.dequeueReusableCellWithIdentifier("WorkItemCell2") as? WorkItemCellModel
            if cell == nil{
                cell = WorkItemCellModel(style: UITableViewCellStyle.Value1, reuseIdentifier: "WorkItemCell2")
            }
            titleText = self.work[indexPath.row + (indexPath.section * 3)]
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell!.iconImage.backgroundColor = workColor[indexPath.row + (indexPath.section * 3)]
            imagePath = ""
            break
            
        case DisplayedMenu.Past:
            titleText = self.iterations[indexPath.row].name
            detailText = NSString(format: "%@ - %@", self.iterations[indexPath.row].startDate, self.iterations[indexPath.row].endDate) as String
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            break
        case DisplayedMenu.Current:
            titleText = self.iterations[indexPath.row].name
            detailText = NSString(format: "%@ - %@", self.iterations[indexPath.row].startDate, self.iterations[indexPath.row].endDate) as String
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            break
        case DisplayedMenu.Future:
            titleText = self.iterations[indexPath.row].name
            detailText = NSString(format: "%@ - %@", self.iterations[indexPath.row].startDate, self.iterations[indexPath.row].endDate) as String
            
            cell!.accessoryType = UITableViewCellAccessoryType.None
            break
            
            
        default:
            println(viewStateManager.sharedInstance.displayedMenu)
        }
        
        cell!.titleText.text = titleText
        cell!.detailText.text = detailText
        cell!.iconImage.image = UIImage(named: imagePath)
        return cell!
    }
    
    //sign out button touch down
    @IBAction func signOutButton(sender: AnyObject) {
        
        if (KeychainWrapper.hasValueForKey("credentials")){
            KeychainWrapper.removeObjectForKey("credentials")
        }
        
        let loginView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView") as! UINavigationController
        navigationController?.presentViewController(loginView, animated: true, completion: nil)
    }
    
}

