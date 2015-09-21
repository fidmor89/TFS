//
//  RestApiManangerTest.swift
//  TFS
//
//  Created by José Morales on 9/20/15.
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
    
    func testMakeHTTPGetRequest() {
        
    }
}