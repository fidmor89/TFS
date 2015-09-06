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
    
    
    func login(account: String, usr: String, pw: String){
        
        let header:String = usr + ":" + pw
        let utf8str: NSData = header.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Basic " + base64Encoded
        
        request.GET("https://almlatam.visualstudio.com/DefaultCollection/_apis/projects?api-version=2.0", parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                return //also notify app of failure as needed
            }
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("response: \(str)") //prints the HTML of the page
                

                if response.statusCode == 200{

                    
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
