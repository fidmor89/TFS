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
    
    func testGetTeams() {
        
        let expectation = expectationWithDescription("GetTeam")
        
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        
        RestApiManager.sharedInstance.getTeams( { (jsObject: JSON) -> () in
            var count: Int = jsObject["count"].int as Int!;
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertGreaterThan(count, 0, "Returned with some teams")
            var jsTeams: JSON = jsObject["value"]
            var apiTeams = [String]()
            for index in 0...(count-1) {
                apiTeams.append(jsTeams[index]["name"].string as String!)
            }
            var teams = ["Url2015Project","Glimpse and Application Insights"]
            XCTAssertEqual(apiTeams, teams, "Correct Teams where found")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: { error in
            XCTAssertNil(error, "Request Timed Out")
        })
    }
    
    func testGetProjects() {
        let expectation = expectationWithDescription("GetProject")
        
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        
        RestApiManager.sharedInstance.getProjects( { (jsObject: JSON) -> () in
            var count: Int = jsObject["count"].int as Int!
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertGreaterThan(count, 0, "Returned with some teams")
            var jsProjects = jsObject["value"]
            var apiProjects = [String]()
            for index in 0...(count - 1) {
                apiProjects.append(jsProjects[index]["name"].string as String!)
            }
            var Projects = ["Infraestructure_DSC", "Application", "Azure_Migration", "SLAB_Integration_with_AI", "iOSTeamExplorer", "Url2015Project Team"]
            XCTAssertEqual(apiProjects, Projects, "Correct Projects where found")
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: { error in
            XCTAssertNil(error, "Request Timed Out")
        })
        
    }
    
    func testGetCollections() {
        let expectation = expectationWithDescription("GetCollections")
        
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        
        RestApiManager.sharedInstance.getCollections( { (jsObject: JSON) -> () in
            var count: Int = jsObject["count"].int as Int!
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertGreaterThan(count, 0, "Returned with some collections")
            var jsCollections = jsObject["value"]
            var apiCollections = [String]()
            for index in 0...(count - 1) {
                apiCollections.append(jsCollections[index]["name"].string as String!)
            }
            var collections = ["DefaultCollection"]
            XCTAssertEqual(apiCollections, collections, "Correct collections where found")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5.0, handler: { error in
            XCTAssertNil(error, "Request Timed Out")
        })
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
    
    func testGetIterations() {
        
        // Success cases
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "fidmor"
        RestApiManager.sharedInstance.pw = "FIDmor12!"
        
//        RestApiManager.sharedInstance.getIterationsByTeamAndProject("", team: "") { json in
//            let count = json["count"].int as Int?
//            //XCTAssertNotNil(count, "Connected to host")
//            //XCTAssertGreaterThan(Int(count!), 0, "Returned with Iterations")
//            XCTAssertEqual(Int(count!), 20, "Returned with Iterations")// Url2015Project iterations
//        }
        
        //Fail case
        //RestApiManager.sharedInstance.baseURL = "https://almlata.visualstudio.com"
        //RestApiManager.sharedInstance.usr = "fidmor"
        //RestApiManager.sharedInstance.pw = "FIDmor12!"
        
        //RestApiManager.sharedInstance.getTeamProjects() { json in
            //let count = json["count"].int as Int?
            //XCTAssertNil(count, "Could not connect to host")
        //}
    }
    
    func testGetCurrentSprint(){
        // Credentials
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "fidmor"
        RestApiManager.sharedInstance.pw = "FIDmor12!"
        
        // Success case
//        RestApiManager.sharedInstance.getCurrentSprint("Url2015Project", team:"iOSTeamExplorer") { json in
//            let count = json["count"].int as Int?
//            XCTAssertNotNil(count, "Connected to host")
//            XCTAssertGreaterThan(Int(count!), 0, "Returned with Iterations")
//        }
    }
    
    func testMakeHTTPGetRequest(){
        // Happy path
        
        var baseURL: String = "https://almlatam.visualstudio.com"
        var usr: String = "fidmor"
        var pw: String = "FIDmor12!"
        let route = baseURL + "/DefaultCollection/_apis/projects?api-version=2.0"
        
        var tester: RestApiManager = RestApiManager()
        
        //Successful case: getting projects and team projects list.
        tester.makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            //Verify data was returned
            XCTAssertNotNil(data, "makeHTTPGetRequest should return data")
            
            //Verify the returned json object is the expected one.
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            let count = json["count"].int as Int?
            XCTAssertNotNil(count, "makeHTTPGetRequest is not returning the expected JSON object")
        })
        
        
        usr = "invalidUser"
        //Failed case: invalid credentials
        tester.makeHTTPGetRequest(route, onCompletion:  {(data: NSData) in
            
            //Verify data was obtained
            XCTAssertNotNil(data, "makeHTTPGetRequest should return data")
            
            //Verify the returned json has not connected.
            let json:JSON = JSON(data: data, options:NSJSONReadingOptions.MutableContainers, error:nil)
            let count = json["count"].int as Int?
            XCTAssertNotNil(count, "makeHTTPGetRequest should return data even if auth failed, it should contain an auth error")
        })
    }
}