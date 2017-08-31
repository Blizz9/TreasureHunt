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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
            //locationManager.startUpdatingLocation()
        }
        
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let fileurl =  dir.appendingPathComponent("data.txt")
        
        if FileManager.default.fileExists(atPath: fileurl.path) {
            do {
                let data = try String(contentsOfFile: fileurl.path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                print(myStrings)
            } catch {
                print(error)
            }
        }
        
        //print(NSHomeDirectory())
        
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let urlString = "http://192.168.1.2:8080/isnearshrines?shrineid=9&latitude=38.308439&longitude=-85.527264"
        let url = NSURL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let temp = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            
            print(temp)
        }
        task.resume()
        
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        let dir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let fileurl =  dir.appendingPathComponent("data.txt")
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let string = "\(hour):\(minutes):\(seconds),\(location.coordinate.latitude.description),\(location.coordinate.longitude.description)\n"
        print(string)
        let data = string.data(using: .utf8, allowLossyConversion: false)!
        
        if FileManager.default.fileExists(atPath: fileurl.path) {
            if let fileHandle = try? FileHandle(forUpdating: fileurl) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try! data.write(to: fileurl, options: Data.WritingOptions.atomic)
        }
    }
    
}

