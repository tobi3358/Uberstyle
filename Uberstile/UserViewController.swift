//
//  UserViewController.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 12/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UserViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var Slidertxt: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var User_idObject = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        User_idObject = UserDefaults.standard.object(forKey: "user_id") as! Int
        if let token = tokenObject as? String
        {
        }
        
        Slidertxt.text = String(describing: Slider.value)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    var center = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location = locations.last as! CLLocation
        
        center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        print(location.coordinate.latitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var value = 50
    @IBAction func Slidervaluechanged(_ sender: Any) {
        // Get Float value from Slider when it is moved.
        value = Int(Slider.value)
        
        // Assign text to string representation of float.
        Slidertxt.text = String(round(Double(value)))
    }
    @IBAction func CreateOrder(_ sender: Any) {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["userid": User_idObject, "user_latitude": center.latitude, "user_longtitude": center.longitude, "radius": value] as [String : Any]
        print(parameters)
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
            //print(datastring)
            //self.setCookies(response: response!)
            //UserDefaults.standard.set(response.json()["Set-Cookie"], forKey: "token")
            print(response)
            
            if let httpresponse = response as? HTTPURLResponse {
                let Respones1 = httpresponse.allHeaderFields["Set-Cookie"] as? String
                print(Respones1)
                UserDefaults.standard.set(Respones1, forKey: "token")
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Login", sender: self)
            }
        }
        task.resume()
    }
}

