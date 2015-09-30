//
//  RestApiManangerTest.swift
//  TFS
//
//  Created by José Morales on 9/20/15.
//  Updated by Fidel Esteban Morales Cifuentes on 9/30/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftHTTP
import XCTest

class RestApiManagerTest: XCTestCase {
    
    //
    func testGetIterationsByTeamAndProject() {
        
    }
    
    func testGetTeamProjects() {
        
        // Success cases
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "fidmor"
        RestApiManager.sharedInstance.pw = "FIDmor12!"
        
        RestApiManager.sharedInstance.getTeamProjects() { json in
            let count = json["count"].int as Int?
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertGreaterThan(Int(count!), 0, "Returned with TeamProjects")
        }
        
        //Fail case
        RestApiManager.sharedInstance.baseURL = "https://almlata.visualstudio.com"
        RestApiManager.sharedInstance.usr = "fidmor"
        RestApiManager.sharedInstance.pw = "FIDmor12!"
        
        RestApiManager.sharedInstance.getTeamProjects() { json in
            let count = json["count"].int as Int?
            XCTAssertNil(count, "Could not connect to host")
        }
    }
    
    func testMakeHTTPGetRequest(){
        // Happy path
        
        var baseURL: String = "https://almlatam.visualstudio.com"
        var usr: String = "fidmor"
        var pw: String = "FIDmor12!"
        let route = baseURL + "/DefaultCollection/_apis/projects?api-version=2.0"
        
        var tester: RestApiManager = RestApiManager()
        
        //Successful case: getting projects and team projects list.
        tester.makeHTTPGetRequest(usr, pw: pw, path: route, onCompletion:  {(data: NSData) in
            //Verify data was returned
            XCTAssertNotNil(data, "makeHTTPGetRequest should return data")
            
            //Verify the returned json object is the expected one.
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            let count = json["count"].int as Int?
            XCTAssertNotNil(count, "makeHTTPGetRequest is not returning the expected JSON object")
        })
        
        
        usr = "invalidUser"
        //Failed case: invalid credentials
        tester.makeHTTPGetRequest(usr, pw: pw, path: route, onCompletion:  {(data: NSData) in
            
            //Verify data was obtained
            XCTAssertNotNil(data, "makeHTTPGetRequest should return data")
            
            //Verify the returned json has not connected.
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            let count = json["count"].int as Int?
            XCTAssertNotNil(count, "makeHTTPGetRequest should return data even if auth failed, it should contain an auth error")
        })
    }
}