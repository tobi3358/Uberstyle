//
//  UserInfoViewController.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 12/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Emailtxt: UITextField!
    @IBOutlet weak var CreatetAt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        let emailObject = UserDefaults.standard.object(forKey: "email")
        let User_idObject = UserDefaults.standard.object(forKey: "user_id")
        Emailtxt.delegate = self

        
        if let token = tokenObject as? String {
        }
        let url = URL(string: "http://172.16.113.184:5000/api/user/details")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    // handle json...
                    print(json)
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(json["email"], forKey: "email")
                        UserDefaults.standard.set(json["user_id"], forKey: "user_id")
                        
                        self.Emailtxt.text = json["email"] as! String
                        //self.nameLabel.text = json["first_name"] as! String
                        //self.lastnameLabel.text = json["surname"] as! String
                        self.nameLabel.text = "tobias"
                        self.lastnameLabel.text = "Brammer"
                        self.CreatetAt.text = json["created"] as! String
                    }
                    
                } else {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

