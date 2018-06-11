//
//  Mainmenu.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 07/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class Mainmenu: UIViewController {
    
    @IBOutlet weak var tokentxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        
        if let token = tokenObject as? String {
            
            tokentxt.text = token
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
