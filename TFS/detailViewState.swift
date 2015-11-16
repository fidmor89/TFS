//
//  detailViewState.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 11/15/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//

import Foundation
import SwiftyJSON

class detailViewState{

    static let sharedInstance = detailViewState()            //To use manager class as a singleton.
    var tasks:[JSON] = []
    var index: Int = 0
}