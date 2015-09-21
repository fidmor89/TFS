//
//  RestApiManager.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 9/20/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHTTP

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestApiManager: NSObject {
   
    static let sharedInstance = RestApiManager()            //To use manager class as a singleton.
    let baseURL = "https://almlatam.visualstudio.com"
    
    func getTeamProjects(usr: String, pw: String, onCompletion: (JSON) -> Void) {
        
        let route = baseURL + "/DefaultCollection/_apis/projects?api-version=2.0"            //API request route
        
        makeHTTPGetRequest(usr, pw: pw, path: route, onCompletion:  {(data: NSData) in
//            println(data)
//            let readableJSON = JSON(data:data,options:NSJSONReadingOptions.MutableContainers, error:nil)

            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)        //parse NS data to JSON.
            onCompletion(json)
        })
        
        


    }
    
    
    func makeHTTPGetRequest(usr: String, pw: String, path: String, onCompletion: (data: NSData) -> Void ){


        let header:String = usr + ":" + pw                                                          //build authorization header.
        let utf8str: NSData = header.dataUsingEncoding(NSUTF8StringEncoding)!                       //encode header
        let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Basic " + base64Encoded               //basic auth header with auth credentials
        
        
        //Make GET request using SwiftHTTP Pod
        request.GET(path, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return                                                                              //notify app
            }
            if let data = response.responseObject as? NSData {
                onCompletion(data: data)                                                            //return data from GET request.
            }
        })
    }
}