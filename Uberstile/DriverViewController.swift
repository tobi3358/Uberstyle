//
//  DriverViewController.swift
//  Uberstile
//
//  Created by Tobias Brammer Fredriksen on 12/06/2018.
//  Copyright © 2018 Tobias Brammer Fredriksen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DriverViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var jsonlement:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        
        if let token = tokenObject as? String {
            
        }
        print(jsonlement)
        
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
        //self.mapView.setRegion(region, animated: true)
        print(location.coordinate.latitude)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func TakeOrder(_ sender: Any) {
        let parameters = ["order_id": ID, "driver_cords": ["latitude": center.latitude, "longtitude":center.longitude]] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://172.16.113.184:5000/api/order/accept")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "PUT" //set http method as POST
        
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
            
            let datastring = String(data: data, encoding: String.Encoding.utf8)
            print(datastring)
            
        })
        task.resume()
    }
}
