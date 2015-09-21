//
//  RestApiManager.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 9/20/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()            //To use manager class as a singleton.
    
    let baseURL = "https://almlatam.visualstudio.com"
    
    func getTeamProjects(usr: String, pw: String, onCompletion: (JSON) -> Void) {
        let route = baseURL + "DefaultCollection/_apis/projects?api-version=2.0"            //API request route
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json:JSON = JSON(data: data)
            onCompletion(json, error)
        })
        task.resume()
    }
}