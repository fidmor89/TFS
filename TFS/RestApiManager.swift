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
    internal var baseURL: String = ""
    internal var usr: String = ""
    internal var pw: String = ""
    internal var collection: String = ""
    internal var lastResponseCode = ""
    
    func validateAuthorization(onCompletionAuth: (Bool) -> Void){
        let route = baseURL + "/_apis/projectcollections?api-version=2.0"
        
        makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            
            switch self.lastResponseCode{
            case "200":
                onCompletionAuth(true)
                break;
            default:
                onCompletionAuth(false)
                break;
            }
        })
    }
    
    func getCollections(onCompletion: (JSON) -> Void) {

        let route = baseURL + "/_apis/projectcollections?api-version=2.0"       //API request route
        
        makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            //parse NSData to JSON
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            onCompletion(json)
        })
    }
    
    func getTeamProjects(onCompletion: (JSON) -> Void) {
        
        let route = baseURL + "/\(collection)/_apis/projects?api-version=2.0"       //API request route
        
        makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            //parse NSData to JSON
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            onCompletion(json)
        })
    }
    
    func getIterationsByTeamAndProject(team: String, onCompletion: (JSON) -> Void){
        let route = baseURL + "/\(collection)/\(team)/_apis/work/teamsettings/iterations?api-version=v2.0-preview"
        
        makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            //parse NSData to JSON
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            onCompletion(json)
        })
    }
    
    /**
    @brief: Creates a HTTPOperation as a HTTP POST request and starts it for you.
    
    @param: path The url you would like to make a request to.
    @param: parameters The parameters are HTTP parameters you would like to send.
    @param: onCompletion The closure that is run when a HTTP Request finished.
    
    @see: makeHTTPGetRequest
    @see: buildAuthorizationHeader
    */
    func makeHTTPPostRequest(path: String, parameters: Dictionary<String,AnyObject>?, onCompletion: (data: NSData) -> Void ){
        
        var request = buildAuthorizationHeader()
        
        //Make POST request using SwiftHTTP Pod
        request.POST(path, parameters: parameters, completionHandler:{(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                self.setLastResponseCode(response)
            }
            if let data = response.responseObject as? NSData {
                self.setLastResponseCode(response)
                onCompletion(data: data)                                                            //return data from POST request.
            }
        })
        
    }
    
    /**
    @brief: Creates a HTTPOperation as a HTTP POST request and starts it for you.
    
    @param: path The url you would like to make a request to.
    @param: onCompletion The closure that is run when a HTTP Request finished.
    
    @see: makeHTTPPostRequest
    @see: buildAuthorizationHeader
    */
    func makeHTTPGetRequest(path: String, onCompletion: (data: NSData) -> Void ){
        
        var request = buildAuthorizationHeader()
        
        //Make GET request using SwiftHTTP Pod
        request.GET(path, parameters: nil, completionHandler: {(response: HTTPResponse) in
            if let err = response.error {
                println("error: \(err.localizedDescription)")
                self.setLastResponseCode(response)
            }
            if let data = response.responseObject as? NSData {
                self.setLastResponseCode(response)
                onCompletion(data: data)                                                            //return data from GET request.
            }
            
        })
    }
    
    func setLastResponseCode(response: HTTPResponse){

        if(response.statusCode != nil){
            self.lastResponseCode = String(response.statusCode!)
        }else{
            self.lastResponseCode = "400"
        }

    }
    
    /**
    @brief: Creates a HTTPOperation as a HTTP POST request and starts it for you.
    
    @param: usr The user you would use for authentication.
    @param: pw The password you would use for authentication.
    
    @see: makeHTTPGetRequest
    @see: makeHTTPPostRequest
    */
    func buildAuthorizationHeader() -> HTTPTask{
        let header:String = usr + ":" + pw                                                          //build authorization header.
        let utf8str: NSData = header.dataUsingEncoding(NSUTF8StringEncoding)!                       //encode header
        let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        var request = HTTPTask()
        request.requestSerializer = HTTPRequestSerializer()
        request.requestSerializer.headers["Authorization"] = "Basic " + base64Encoded               //basic auth header with auth credentials
        return request;
    }
    
}