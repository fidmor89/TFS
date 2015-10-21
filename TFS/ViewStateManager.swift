//
//  ViewStateManager.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 10/17/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation

class viewStateManager {
    
    var displayedMenu : DisplayedMenu = DisplayedMenu.Collections
    static let sharedInstance = viewStateManager()            //To use manager class as a singleton.
    
}
enum DisplayedMenu: Int {
    case Collections = 1
    case Projects = 2
    case Teams = 3
    case Work = 4
    case Sprints = 5
    case Epic = 6
    case Feature = 7
    case PBI = 8
    case Past = 9
    case Current = 10
    case Future = 11
}