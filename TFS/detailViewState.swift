//
//  detailViewState.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 11/15/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
class detailViewState{

    var areaPath : String? = nil
    var iterationPath : String? = nil
    
    static let sharedInstance = detailViewState()            //To use manager class as a singleton.
}