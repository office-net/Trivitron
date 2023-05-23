import CoreData
import IQKeyboardManagerSwift
import SwiftyJSON
import CoreLocation
//
//  AppDelegate.swift
//  IOS
//
//  Created by Netcommlabs on 15/11/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate{
//
//    private var locationManager:CLLocationManager?
//    var lat = ""
//    var long = ""
//    var Address = ""
//    var n = 120

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        IQKeyboardManager.shared.enable = true
//        var timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
//        getUserLocation()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
    }


}


//extension AppDelegate
//{
//    @objc func getLocation()
//    {
//
////
//        ApiCallingTrackLocation(lat: self.lat, long: self.long, Address: self.Address)
//
//
//    }
//
//
//    func getUserLocation() {
//        locationManager = CLLocationManager()
//        locationManager?.requestAlwaysAuthorization()
//        locationManager?.startUpdatingLocation()
//        locationManager?.delegate = self
//        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager?.allowsBackgroundLocationUpdates = true
//
//    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            self.lat = "Lat : \(location.coordinate.latitude) "
//            self.long = "Lng : \(location.coordinate.longitude)"
//
//            let UserLocation = locations[0] as CLLocation
//            let GeoCoder = CLGeocoder()
//            GeoCoder.reverseGeocodeLocation(UserLocation) { (Placemarks,error) in
//                if (error != nil)
//                {
//                    print("Error in reverseGeocodeLocation ")
//                }
//
//
//                let placemark = Placemarks! as [CLPlacemark]
//                if (placemark.count>0)
//                {
//                    let p = Placemarks![0]
//                    let street = p.subLocality ?? ""
//                    let locatity = p.locality ?? ""
//                    let subThoroughfare  = p.postalCode ?? ""
//                    let addmistraivearea = p.administrativeArea ?? ""
//                    let country = p.country ?? ""
//                    self.Address = "\(street) \(locatity) \(subThoroughfare) \(addmistraivearea) \(country)"
//
//                }
//
//
//
//            }
//
//
//
//        }
//    }
//
//
//
//
//    func ApiCallingTrackLocation(lat:String , long:String , Address:String)
//    {  var parameters:[String:Any]?
//       if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
//
//        { parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":UserID,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":"","AccuracyMeters":"100","Address":Address]] ]
//          }
//        else
//        {
//            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":0,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":"","AccuracyMeters":"100","Address":Address]] ]
//        }
//
//        Networkmanager2.postRequest(remainingUrl:"TrackedUserLocations", parameters: parameters!) { (response,data) in
//            let json:JSON = response
//            let status = json["Status"].intValue
//            if status == 1
//            {
//                print(json)
//            }
//
//        }
//    }
//}
