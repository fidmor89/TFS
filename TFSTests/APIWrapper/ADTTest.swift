//
//  ADTTest.swift
//  TFS
//
//  Created by José Morales on 9/20/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import XCTest

class teamProjectsTest : XCTestCase {
    
    func testTeamProjectsInit() {
        
        //Success Case
        let teamProject = teamProjects(id: "Prueba", name: "Nuevo", description: "Es un projecto de prueba", url: "URLGenerico", state: "Commited", revision: 8)
        XCTAssertNotNil(teamProject)
        
        //Fail case
        let invalidTeamProject = teamProjects(id: "", name: "Nuevo", description: "", url: "", state: "", revision: 9)
        XCTAssertNil(invalidTeamProject, "TeamProject not valid")
        
    }
    
}