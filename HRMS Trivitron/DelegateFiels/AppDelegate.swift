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

    private var locationManager:CLLocationManager?
    var lat = ""
    var long = ""
    var Address = ""
    var n = 120

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        IQKeyboardManager.shared.enable = true
        var timer = Timer.scheduledTimer(timeInterval: TimeInterval(n), target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        getUserLocation()
       
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      
    }


}


extension AppDelegate
{
    @objc func getLocation()
    {

//
        ApiCallingTrackLocation(lat: self.lat, long: self.long, Address: self.Address)


    }


    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.allowsBackgroundLocationUpdates = true

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.lat = "Lat : \(location.coordinate.latitude) "
            self.long = "Lng : \(location.coordinate.longitude)"

            // getting address from coordinate using reverseGeocode
            let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
                 
                   let geocoder = CLGeocoder()
                   geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarkArray, error) in
                       guard let placemarks = placemarkArray, let placemark = placemarks.first else {
                           return
                       }
                 
                       // creating complete address
                       var address = ""
//                       if let name = placemark.name {
//                           address += "\(name))"
//                       }
                       if let thoroughfare = placemark.thoroughfare {
                           address += "\(thoroughfare), "
                       }
                       if let subThoroughfare = placemark.subThoroughfare {
                           address += "\(subThoroughfare)"
                       }
                       if let locality = placemark.locality {
                           address += "\(locality)"
                       }
                       if let subLocality = placemark.subLocality {
                           address += ", \(subLocality)"
                       }
                       if let administrativeArea = placemark.administrativeArea {
                           address += ", \(administrativeArea)"
                       }
                       if let postalCode = placemark.postalCode {
                           address += ", \(postalCode)"
                       }
                       if let country = placemark.country {
                           address += ", \(country)"
                       }
                       self.Address = address
                     //  print(address)
                   })

            
            
            
            
            
            

        }
    }




    func ApiCallingTrackLocation(lat:String , long:String , Address:String)
    {  var parameters:[String:Any]?
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
       if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
       

        { parameters = ["TokenNo":token ?? "","UserId":UserID,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":"","AccuracyMeters":"100","Address":Address] as [String : Any]] ]
          }
        else
        {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":0,"LocationArrList":[["LocationID":0,"Latitude":lat,"Longitude":long,"Timestamp":"","AccuracyMeters":"100","Address":Address] as [String : Any]] ]
        }

        Networkmanager2.postRequest(remainingUrl:"TrackedUserLocations", parameters: parameters!) { (response,data) in
            let json:JSON = response
            let status = json["Status"].intValue
            if status == 1
            {
                print(json)
            }

        }
    }
}
