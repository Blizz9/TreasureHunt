//
//  ViewController.swift
//  TreasureHunt
//
//  Created by Nicholas Blizard on 3/14/17.
//  Copyright © 2017 Pixelism Games. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    var locationManager: CLLocationManager!
    //var annotation: MKPointAnnotation!
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var altitude: CLLocationDistance = 0.0
    
    var shrine0Text: String = ""
    var shrine1Text: String = ""
    var shrine2Text: String = ""
    var shrine3Text: String = ""
    
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    
    @IBOutlet weak var shrine0Label: UILabel!
    @IBOutlet weak var shrine1Label: UILabel!
    @IBOutlet weak var shrine2Label: UILabel!
    @IBOutlet weak var shrine3Label: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    // MARK: - Actions
    @IBAction func getLocationButton(_ sender: UIButton) {
        latitudeLabel.text = latitude.description
        longitudeLabel.text = longitude.description
        altitudeLabel.text = altitude.description
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        
        //let urlString = "http://54.89.57.56:8080/rest/checklocation?latitude=" + latitude.description + "&longitude=" + longitude.description
        //let urlString = "http://192.168.1.2:8080/isnearshrines?shrineid=3&latitude=" + latitude.description + "&longitude=" + longitude.description
        //38.308439&longitude=-85.527264
        let urlString = "http://192.168.1.2:8080/isnearshrines?shrineid=3&latitude=38.308439&longitude=-85.527264"
        let url = NSURL(string: urlString)
        //let url = NSURL(string: "http://ec2-54-175-91-55.compute-1.amazonaws.com:8080/rest/location?latitude=1.2&longitude=45.7")
        
        shrine0Label.text = shrine0Text
        shrine1Label.text = shrine1Text
        shrine2Label.text = shrine2Text
        shrine3Label.text = shrine3Text
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let temp = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
            print(temp)
            
//            var data: NSData = temp.data(using: String.Encoding.utf8.rawValue)! as NSData
            
//            do {
//                
//                let JsonDict = try JSONSerialization.jsonObject(with: data as Data, options: [])
//                if let dictFromJSON = JsonDict as? [String:String]
//                {
//                    self.shrine0Text = dictFromJSON["closestShrine0"]!
//                    self.shrine1Text = dictFromJSON["closestShrine1"]!
//                    self.shrine2Text = dictFromJSON["closestShrine2"]!
//                    self.shrine3Text = dictFromJSON["closestShrine3"]!
//                }
//            } catch let error as NSError {
//                print(error)
//            }
        }
        
        task.resume()
    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation()
//        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        altitude = location.altitude
    }
}
