//
//  Cell.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 13/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation


class Cell: NSObject {
    
    //properties
    
    var ID: Int?
    var origin: String?
    var object: NSDictionary?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name parameters
    
    init(ID: Int, origin: String, object:NSDictionary) {
        
        self.ID = ID
        self.origin = origin
        self.object = object
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(ID!) Origin: \(origin) object: \(object)"
        
        
    }
    
    
}

