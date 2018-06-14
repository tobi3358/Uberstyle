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
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name parameters
    
    init(ID: Int) {
        
        self.ID = ID
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "ID: \(ID!)"
        
    }
    
    
}

