//
//  AppDelegate.swift
//  TreasureHunt
//
//  Created by Nicholas Blizard on 3/14/17.
//  Copyright © 2017 Pixelism Games. All rights reserved.
//

import CoreLocation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager!

    //var isMonitoringSignificant = false
    
    //var locationHistory = [CLLocationCoordinate2D]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        logMessage("Application Started")
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        logMessage("Vendor ID: \(String(describing: deviceID))")
        
        logMessage("Home Directory: \(NSHomeDirectory())")
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        logMessage("Background Fetch Turned On")
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            //locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
            
            //isMonitoringSignificant = false
        }
        
        // prints out current contents of log file as it starts
        //let logDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        //let logFilePath =  logDirectory.appendingPathComponent("log.txt")
        //if FileManager.default.fileExists(atPath: logFilePath.path) {
        //    do {
        //        let logFileData = try String(contentsOfFile: logFilePath.path, encoding: .utf8)
        //        print(logFileData.components(separatedBy: .newlines))
        //    } catch {
        //        print(error)
        //    }
        //}
        
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logMessage("Background Fetch Called")
        
        //let urlString = "http://192.168.1.2:8080/isnearshrines?shrineid=9&latitude=38.308439&longitude=-85.527264"
        //let url = NSURL(string: urlString)
        //let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
        //    let temp = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
        //    print(temp)
        //}
        //task.resume()
        
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        logMessage("Application Will Resign Active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        logMessage("Application Did Enter Background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        logMessage("Application Will Enter Foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        logMessage("Application Did Become Active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        logMessage("Application Will Terminate")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        
        logMessage("Detailed Location: \(location.coordinate.latitude.description),\(location.coordinate.longitude.description) | \(String(describing: deviceID))")
        
        /*
        if (isMonitoringSignificant) {
            logMessage("Significant Location: \(location.coordinate.latitude.description),\(location.coordinate.longitude.description)")
            
            logMessage("Significant location change occured, starting detailed updating")
            
            isMonitoringSignificant = false
            
            locationManager.stopMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        } else {
            logMessage("Detailed Location: \(location.coordinate.latitude.description),\(location.coordinate.longitude.description)")
            
            if (locationHistory.count == 100) {
                logMessage("Removing location history item")
                locationHistory.remove(at: 0)
            }
            locationHistory.append(location.coordinate)
            
            if (locationHistory.count == 100) {
                var minLat = 100.0
                var maxLat = -100.0
                var minLon = 200.0
                var maxLon = -200.0
                for coordinate in locationHistory {
                    minLat = min(minLat, coordinate.latitude)
                    maxLat = max(maxLat, coordinate.latitude)
                    minLon = min(minLon, coordinate.longitude)
                    maxLon = max(maxLon, coordinate.longitude)
                }
            
                logMessage("Latitude: Min:\(minLat) , Max:\(maxLat) | Longitude: Min:\(minLon) , Max:\(maxLon)")
                
                minLat = minLat * Double.pi / 180.0
                maxLat = maxLat * Double.pi / 180.0
                minLon = minLon * Double.pi / 180.0
                maxLon = maxLon * Double.pi / 180.0
            
                let havdr = hav(maxLat - minLat) + cos(minLat) * cos(maxLat) * hav(maxLon - minLon)
                let distance = 2.0 * 6371000.0 * asin(sqrt(havdr))
            
                logMessage("Distance: \(distance)")
                
                if (distance < 100.0) {
                    logMessage("Location has not drastically changed in 100 samples, starting to monitor significant location changes")
                    
                    locationHistory.removeAll()
                    isMonitoringSignificant = true
                    
                    locationManager.stopUpdatingLocation()
                    locationManager.startMonitoringSignificantLocationChanges()
                }
            } else {
                logMessage("Waiting on 100 location samples: \(locationHistory.count)")
            }
        }
        */
    }
    
    func logMessage(_ message: String) {
        let logDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let logFilePath =  logDirectory.appendingPathComponent("log.txt")
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let logMessage = "\(month)-\(day) \(hour):\(minutes):\(seconds) | \(message)\n"
        print(logMessage)
        
        let logMessageData = logMessage.data(using: .utf8, allowLossyConversion: false)!
        
        if FileManager.default.fileExists(atPath: logFilePath.path) {
            if let logFile = try? FileHandle(forUpdating: logFilePath) {
                logFile.seekToEndOfFile()
                logFile.write(logMessageData)
                logFile.closeFile()
            }
        } else {
            try! logMessageData.write(to: logFilePath, options: Data.WritingOptions.atomic)
        }
    }
    
    func hav(_ theta: Double) -> Double {
        return pow(sin(theta/2), 2)
    }
}

