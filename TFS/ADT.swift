//
//  ADT.swift
//  TFS
//
//  Created by Fidel Esteban Morales Cifuentes on 9/20/15.
//  Copyright (c) 2015 Fidel Esteban Morales Cifuentes. All rights reserved.
//


public class teamProjects {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var url: String = ""
    var state: String = ""
    var revision: Int = 0
    
    init(id:String, name: String, description:String, url:String, state:String, revision: Int){
        self.id = id ?? ""
        self.name = name ?? ""
        self.description = description ?? ""
        self.url = url ?? ""
        self.state = state ?? ""
        self.revision = revision ?? -1
    }
}