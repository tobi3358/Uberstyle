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
    @IBOutlet weak var FromLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var Trip_durationLabel: UILabel!
    @IBOutlet weak var CreatedAtLabel: UILabel!
    var locationManager: CLLocationManager!
    var jsonlement:NSDictionary = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tokenObject = UserDefaults.standard.object(forKey: "token")
        
        if let token = tokenObject as? String {
            
        }
        print(jsonlement)
        
        CreatedAtLabel.text = jsonlement["create_time"]! as! String
        FromLabel.text = jsonlement["origin"]! as! String
        ToLabel.text = jsonlement["destination"]! as! String
        priceLabel.text = "\(jsonlement["price"]!) Kr."
        DistanceLabel.text = "\(jsonlement["distance"]! as! Double / 1000) Km"
        Trip_durationLabel.text = "\(jsonlement["trip_duration"]! as! Int / 60) Min"
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
        let parameters = ["order_id": jsonlement["order_id"], "driver_cords": ["latitude": center.latitude, "longtitude":center.longitude]] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "http://localhost/api/order/accept")! //change the url
        
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
