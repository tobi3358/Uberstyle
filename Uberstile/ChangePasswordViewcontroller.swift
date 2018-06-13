//
//  ChangePasswordViewcontroller.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 12/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var OldPasswordtxt: UITextField!
    @IBOutlet weak var NewPasswordtxt: UITextField!
    var email1 = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        let emailObject = UserDefaults.standard.object(forKey: "email")
        
        if let token = tokenObject as? String {
        }
        if let email = emailObject as? String {
            email1 = email
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SavePassword(_ sender: Any) {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["email": email1, "password": OldPasswordtxt.text, "new_password": NewPasswordtxt.text] as [String : Any]
        
        //url
        let url = URL(string: "http://localhost/api/user/password/change")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("Authorization", forHTTPHeaderField: "Bearer: \(token)")
        //request.setValue("Bearer: "+(token), forHTTPHeaderField: "Authorization")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error -> Void in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let datastring = String(data: data, encoding: String.Encoding.utf8)
            //print(datastring)
            //self.setCookies(response: response!)
            //UserDefaults.standard.set(response.json()["Set-Cookie"], forKey: "token")
            print(response)
        }
        task.resume()
    }
}
