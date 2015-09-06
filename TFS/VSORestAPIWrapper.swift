//
//  VSORestAPIWrapper.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 9/5/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftHTTP

class APIWrapper {
    
    
    func login(){
        var request = HTTPTask()
        //the auth closures will continually be called until a successful auth or rejection
        var attempted = false
        request.auth = {(challenge: NSURLAuthenticationChallenge) in
            if !attempted {
                attempted = true
                return NSURLCredential(user: "fidmor", password: "FIDmor12!", persistence: NSURLCredentialPersistence.Permanent)
            }
            return nil //auth failed, nil causes the request to be properly cancelled.
        }
        
        
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Basic ZmlkbW9yOkZJRG1vcjEyIQ=="
        
        request.GET("https://almlatam.visualstudio.com/DefaultCollection/_apis/projects?api-version=2.0", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)") //prints the HTML of the page
                
                if response.statusCode == 200{

                    
                    var data2: NSData = str!.dataUsingEncoding(NSUTF8StringEncoding)!
                    var error: NSError?

                    let anyObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                        error: &error)
                    println("Error: \(error)")
                    
                    var list:Array<teamProjects> = []
                    list = self.parseJson(anyObj!)
                    
                }
                
                
            }
        })
    }
    
    func parseJson(anyObj:AnyObject) -> Array<teamProjects>{
        
        var list:Array<teamProjects> = []
        
        if  anyObj is Array<AnyObject> {
            
            var b:teamProjects = teamProjects()
            
            for json in anyObj as! Array<AnyObject>{
                b.id = (json["id "] as AnyObject? as? String) ?? "" // to get rid of null
                b.name = (json["name"] as AnyObject? as? String) ?? ""
                b.description = (json["description"] as AnyObject? as? String) ?? ""
                b.url = (json["url"] as AnyObject? as? String) ?? ""
                b.state = (json["state"] as AnyObject? as? String) ?? ""
                b.revision  =  (json["revision"]  as AnyObject? as? Int) ?? 0     //null -> 0
                
                list.append(b)
            }
        }
        
        return list
        
    }
    
}//class
struct teamProjects {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var url: String = ""
    var state: String = ""
    var revision: Int = 0
}
