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
enum DisplayedMenu: String {
    case Collections = "Collections"
    case Teams = "Teams"
    case Projects = "Projects"
}