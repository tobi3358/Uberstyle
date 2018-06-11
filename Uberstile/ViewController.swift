//
//  ViewController.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 04/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var EmailTextfield: UITextField!
    @IBOutlet weak var PasswordTextfield: UITextField!
    var token = "";
    let tokenObject = UserDefaults.standard.object(forKey: "token")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let token = tokenObject as? String {
            
            EmailTextfield.text = token
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
     func Gettoken(){
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["email": EmailTextfield.text, "password": PasswordTextfield.text] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://localhost/api/login")! //change the url
        
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
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    self.token = json["token"] as! String
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
     */
    
    private func setCookies(response: URLResponse) {
        
        if let httpResponse = response as? HTTPURLResponse {
            if let headerFields = httpResponse.allHeaderFields as? [String: String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: response.url!)
                
            }
        }
    }
    
    func login(){
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["email": EmailTextfield.text, "password": PasswordTextfield.text] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://localhost/api/user/login")! //change the url
        
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
            print(datastring)
            self.setCookies(response: response!)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        }
        task.resume()
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        //Gettoken()
        login()
        sleep(3)
        UserDefaults.standard.set(token, forKey: "token")
    }
}

