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
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(UserViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(uilpgr)
        
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
        print(center.latitude)
    }
    
    var annotation_latitude = 0.0
    var annotation_longitude = 0.0
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        mapView.removeAnnotations(self.mapView.annotations)
        let touchPoint = gestureRecognizer.location(in: self.mapView)
        
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        annotation.title = "New place"
        annotation.subtitle = "Maybe I'll go here too..."
        
        mapView.addAnnotation(annotation)
        annotation_latitude = coordinate.latitude
        annotation_longitude = coordinate.longitude
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var value1 = 50
    @IBAction func Slidervaluechanged(_ sender: Any) {
        // Get Float value from Slider when it is moved.
        value1 = Int(Slider.value)
        
        // Assign text to string representation of float.
        Slidertxt.text = String(round(Double(value1)))
    }
    
    func displayAlert(title: String, message: String) {
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }
    @IBAction func CreateOrder(_ sender: Any) {
        if annotation_longitude == 0.0 {
            displayAlert(title: "Error in form", message: "Destination has to be selected")
        } else {
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        let parameters = ["price": value1, "destination_cords": ["latitude": annotation_latitude, "longtitude": annotation_longitude], "user_cords": ["latitude": center.latitude, "longtitude": center.longitude]] as [String : Any]
        print(parameters)
        let url = URL(string: "http://localhost/api/order/create")! //change the url
        
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
            //self.setCookies(response: response!)
            //UserDefaults.standard.set(response.json()["Set-Cookie"], forKey: "token")
            print(response)
            
            if let httpresponse = response as? HTTPURLResponse {
                let Respones1 = httpresponse.allHeaderFields["Set-Cookie"] as? String
                print(Respones1)
                UserDefaults.standard.set(Respones1, forKey: "token")
            }
        }
        task.resume()
        }
    }
}

