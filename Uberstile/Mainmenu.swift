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
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logud(_ sender: Any) {
        let url = NSURL(string: "http://localhost/api/user/logout") //Remember to put ATS exception if the URL is not https
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") //Optional
        request.httpMethod = "PUT"
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
        let data = "".data(using: String.Encoding.utf8)
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            if error != nil {
                
                //handle error
            }
            else {
                
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Parsed JSON: '\(jsonStr)'")
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "token")
                defaults.synchronize()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "Logud", sender: self)
                }
            }
        }
        dataTask.resume()
        
    }
}
