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
    
    func testGetIterationsByTeamAndProject() {
        let expectation = expectationWithDescription("GetIterations")
        
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        RestApiManager.sharedInstance.getIterationsByTeamAndProject({ (jsObject: JSON) -> () in
            var count: Int = jsObject["count"].int as Int!
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertGreaterThan(count, 0, "Returned with some iterations")
            var jsIterations = jsObject["value"]
            var apiIterations = [String]()
            for index in 0...(count - 1) {
                apiIterations.append(jsIterations[index]["name"].string as String!)
            }
            XCTAssertEqual(apiIterations[0], "SP1 - roadmap, storyboard and auth", "Correct first iteration")
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5.0, handler: { error in
            XCTAssertNil(error, "Request Timed Out")
        })

    }
    
    func testGetCurrentSprint(){
        let expectation = expectationWithDescription("GetIterations")
        
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        RestApiManager.sharedInstance.getCurrentSprint({ (jsObject: JSON) -> () in
            var count: Int = jsObject["count"].int as Int!
            XCTAssertNotNil(count, "Connected to host")
            XCTAssertEqual(count, 1, "Returned with current iteration")
            var jsCurrentSprint = jsObject["value"]
            var dateFormatter : NSDateFormatter = NSDateFormatter()
            var sDate : String = jsCurrentSprint[0]["attributes"]["startDate"].string as String!
            var eDate : String = jsCurrentSprint[0]["attributes"]["finishDate"].string as String!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            var startDate : NSDate = dateFormatter.dateFromString(sDate)!
            var endDate : NSDate = dateFormatter.dateFromString(eDate)!
            endDate = endDate.dateByAddingTimeInterval(60*60*24)
            var now : NSDate = NSDate()
            if (((NSCalendar.currentCalendar().compareDate(startDate, toDate: now, toUnitGranularity: NSCalendarUnit.CalendarUnitHour) == NSComparisonResult.OrderedAscending) || (NSCalendar.currentCalendar().compareDate(startDate, toDate: now, toUnitGranularity: NSCalendarUnit.CalendarUnitHour) == NSComparisonResult.OrderedSame)) && ((NSCalendar.currentCalendar().compareDate(endDate, toDate: now, toUnitGranularity: NSCalendarUnit.CalendarUnitHour) == NSComparisonResult.OrderedDescending) || ((NSCalendar.currentCalendar().compareDate(endDate, toDate: now, toUnitGranularity: NSCalendarUnit.CalendarUnitHour) == NSComparisonResult.OrderedSame)))) {
                XCTAssertTrue(true, "It's the current sprint")
            }
            else {
                XCTAssertTrue(false, "It's not the current sprint")
            }
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(5.0, handler: { error in
            XCTAssertNil(error, "Request Timed Out")
        })
    }
    
    func testGetTask() {
        let expectation = expectationWithDescription("getTasks")
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        RestApiManager.sharedInstance.iterationPath = "Url2015Project\\iOS_Team_Explorer_Collection\\SP7 - Display Work Items and Look and Feel"
        
        RestApiManager.sharedInstance.getTaks({ (jsObject: JSON) -> () in
            var jsTasks: JSON = jsObject["workItems"]
            var count: Int = jsTasks.count
            XCTAssertGreaterThan(count, 0, "Returned with some tasks")
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5.0, handler: {error in
            XCTAssertNil(error, "Request Timed Out")
        })
        
    }
    
    func testGetEpics() {
        let expectation = expectationWithDescription("getEpics")
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        
        RestApiManager.sharedInstance.getEpics({ (jsObject: JSON) -> () in
            var jsTasks: JSON = jsObject["workItems"]
            var count: Int = jsTasks.count
            XCTAssertGreaterThan(count, 0, "Returned with some epics")
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5.0, handler: {error in
            XCTAssertNil(error, "Request Timed Out")
        })
    }
    
    func testGetFeatures() {
        let expectation = expectationWithDescription("getFeatures")
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        
        RestApiManager.sharedInstance.getFeatures({ (jsObject: JSON) -> () in
            var jsTasks: JSON = jsObject["workItems"]
            var count: Int = jsTasks.count
            XCTAssertGreaterThan(count, 0, "Returned with some epics")
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5.0, handler: {error in
            XCTAssertNil(error, "Request Timed Out")
        })
    }
    
    func testGetPBI() {
        let expectation = expectationWithDescription("getPBI")
        //Success case
        RestApiManager.sharedInstance.baseURL = "https://almlatam.visualstudio.com"
        RestApiManager.sharedInstance.usr = "jlmruiz"
        RestApiManager.sharedInstance.pw = "Prueba2015"
        RestApiManager.sharedInstance.collection = "DefaultCollection"
        RestApiManager.sharedInstance.projectId = "Url2015Project"
        RestApiManager.sharedInstance.teamId = "iOSTeamExplorer"
        
        RestApiManager.sharedInstance.getPBI({ (jsObject: JSON) -> () in
            var jsTasks: JSON = jsObject["workItems"]
            var count: Int = jsTasks.count
            XCTAssertGreaterThan(count, 0, "Returned with some epics")
            expectation.fulfill()
            
        })
        
        waitForExpectationsWithTimeout(5.0, handler: {error in
            XCTAssertNil(error, "Request Timed Out")
        })
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