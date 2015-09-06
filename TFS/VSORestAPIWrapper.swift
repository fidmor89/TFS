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
    
    func getTeamProjects(account: String, usr: String, pw: String){
        
        let url: String = "https://\(account).visualstudio.com/DefaultCollection/_apis/projects?api-version=2.0"
        makeHTTPRequest(url, usr: usr, pw: pw)
    }
    
    
    func makeHTTPRequest(url: String, usr: String, pw: String){
        
        let header:String = usr + ":" + pw
        let utf8str: NSData = header.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Basic " + base64Encoded
        
        request.GET(url, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)") //prints the HTML of the page
                
                
                switch (response.statusCode!) {
                case 200://Success, and there is a response body.
                    
                    break;
                case 201:   //Success, when creating resources. Some APIs return 200 when successfully creating a resource. Look at the docs for the API you're using to be sure.
                    
                    break;
                case 203://Non-Authoritative Information: missing auth information.
                    
                    break;
                case 204: //Success, and there is no response body. For example, you'll get this when you delete a resource.
                    
                    break;
                case 400: //The parameters in the URL or in the request body aren't valid.
                    
                    break;
                case 403: //The authenticated user doesn't have permission to perform the operation.
                    
                    break;
                case 404://The resource doesn't exist, or the authenticated user doesn't have permission to see that it exists.
                    
                    break;
                case 409: //There's a conflict between the request and the state of the data on the server. For example, if you attempt to submit a pull request and there is already a pull request for the commits, the response code is 409.
                    
                    break;
                    
                default://unhandled status code, probably a good idea to send it into AI.
                    break;
                }
            }
        })
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
