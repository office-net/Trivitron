import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SemiModalViewController
protocol reloadData {
    func ab()
   
}
class MarkAttendanceVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    var locationManager = CLLocationManager()
    var lat : Double?
    var long :Double?
    var currentLocation: CLLocation!
    var strPunchInOut = ""
    var strintime = ""
    var strouttime = ""
    var strMatching = "0"
    var delegate:reloadData?
    var strmag = ""
    
    var arr:JSON = ["ankit":"1"]
    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var lbl_Address: UILabel!

    
    @IBOutlet weak var btn_MarkAttendance: UIButton!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mark Attendance"
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MarkAttendanceVC.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            let dialogMessage = UIAlertController(title: base.alertname, message: "You are not not connected with internet", preferredStyle: .alert)
           let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            dialogMessage.addAction(ok)
           self.present(dialogMessage, animated: true, completion: nil)
        //===========================================================================
        
        
        
        case .online(.wwan):
            print("Connected via WWAN")
            print("Connected via WiFi")
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
            
            mapview.delegate = self
            mapview.mapType = .standard
            mapview.isZoomEnabled = true
            mapview.isScrollEnabled = true
            if let coor = mapview.userLocation.location?.coordinate{
                mapview.setCenter(coor, animated: true)
                
            }
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
               CLLocationManager.authorizationStatus() == .authorizedAlways) {
                currentLocation = locationManager.location
                print(currentLocation.coordinate.latitude)
                self.lat = currentLocation.coordinate.latitude
                print(currentLocation.coordinate.longitude)
                self.long = currentLocation.coordinate.longitude
            }
            
        //===========================================================================================================
        
        case .online(.wiFi):
            print("Connected via WiFi")
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
            
            mapview.delegate = self
            mapview.mapType = .standard
            mapview.isZoomEnabled = true
            mapview.isScrollEnabled = true
            if let coor = mapview.userLocation.location?.coordinate{
                mapview.setCenter(coor, animated: true)
            }
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways) {
                currentLocation = locationManager.location
                self.lat = currentLocation.coordinate.latitude
                print(self.lat!)
                self.long = currentLocation.coordinate.longitude
                print(self.long!)
            }
            
        }
        GetInOutStatusAPI()
        getLatLong()
       
        
    }
    
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
        
    }
    
    @IBAction func btn_MarkAttendance(_ sender: Any) {
        SavePunchInOutDetailsAPI()
    }
    
    
    func getLatLong()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        let UserID = UserDefaults.standard.object(forKey: "UserID")as? Int
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        parameters = ["TokenNo": token!, "UserId": UserID!, "VersionName": ""]
        AF.request( base.url+"GetBannerImages", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self)  { response in
                switch response.result
                {
                case .success(let value):
                    let json:JSON = JSON(value)
                    //  print(json)
                    let status =  json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        //====================PushNotificationList=============
                        let coordinateCurrent = CLLocation(latitude: self.lat ?? 0, longitude: self.long ?? 0)
                        print("==================Current cordinate\(coordinateCurrent)")
                        let notificationlist:JSON = json["LatlongdisattList"]
                        print("==================cordinates Array \(notificationlist)")
                        if notificationlist.isEmpty == true
                        {
                            print(notificationlist)
                        }
                        else
                        {
                            for i in 0...notificationlist.count - 1 {
                                let latitude = notificationlist[i]["Latitude"].stringValue
                                let longitude = notificationlist[i]["Longitude"].stringValue
                                let distancefromApi =  notificationlist[i]["Distance"].stringValue
                                print("api lat long and distance is ================ ",Double(distancefromApi) ?? 0,"  ",latitude,longitude)
                                
                                let distance = coordinateCurrent.distance(from: CLLocation(latitude: Double("\(latitude)") ?? 0, longitude: Double("\(longitude)") ?? 0))
                                
                                if distance <= Double(distancefromApi) ?? 0
                                {
                                    print("from cordinste \(i)"," distance is \(distance) "," and Attendence Status is sucess")
                                    self.strMatching = "1"
                                    break
                                }
                                print("++++++++++++++++++++++++++++",distance)
                            }
                            if self.strMatching == "1"
                            {
                                print("Succes")
                            }
                            else
                            {
                               
                                let alertController = UIAlertController(title: base.alertname, message: self.strmag, preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.dismissSemiModalView()
                                }
                                // Add the actions
                                alertController.addAction(okAction)
                                // Present the controller
                                DispatchQueue.main.async {
                                    
                                    self.present(alertController, animated: true)
                                }
                            }
                            
                        }
                    }
                    else
                    {   CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
    func GetInOutStatusAPI()
    {    var userid = 0
        if let Userid = UserDefaults.standard.object(forKey: "UserID")as? Int
        {
            userid = Userid
        }
        
        var parameters:[String:Any]?
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        if let EmpCode = UserDefaults.standard.object(forKey: "EmpCode") as? String   {
            parameters = ["EmpCode":EmpCode,"TokenNo":token!,"UserId":userid]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","EmpCode":"0"]
        }
        
        AF.request( base.url+"GetInOutStatus", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                switch response.result
                {
                
                case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status =  json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.strmag =  json["distanceMessage"].stringValue
                       
                        let Intime =  json["InTime"].stringValue
                        self.strintime = Intime
                        let outtime = json["OutTime"].stringValue
                        self.strouttime = outtime
                        if Intime == "0"
                        {
                            self.btn_MarkAttendance.layer.name = "Day Off"
                            self.strPunchInOut = "PUNCHOUT"
                            
                        }
                        else if Intime == "1"
                        {
                            self.btn_MarkAttendance.layer.name = "Mark Attendance"
                            self.strPunchInOut = "PUNCHIN"
                        }
                        if outtime == "0"
                        {
                            self.btn_MarkAttendance.layer.name = "Mark Attendance"
                            self.strPunchInOut = "PUNCHIN"
                        }
                        else if outtime == "1"
                        {
                            self.btn_MarkAttendance.layer.name = "Day Off"
                            self.strPunchInOut = "PUNCHOUT"
                        }
                        
                        
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    }
                case .failure(let error ):
                    print(error.localizedDescription)
                }
                
                
            }
    }
    func SavePunchInOutDetailsAPI ()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date)
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":token!,"UserID":UserID,"Latitude":lat ?? 0,"Longitude":long ?? 0,"Address":self.lbl_Address.text!,"Type":strPunchInOut,"DateTime":myString,"FileInBase64":"","FileExt":"","AttendanceType":"ONLINE","Intime":self.strintime,"OutTime":self.strouttime]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
        }
        AF.request( base.url+"SavePunchInOutDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                switch response.result
                {
                
                case .success(let value):
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: false)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                           
                            self.dismissSemiModalView()
                            self.delegate?.ab()
                            self.present(alertController, animated: true)
                        }
                        
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                   
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: false)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                        
                    }
                    
                case .failure(let error):
                    print(parameters!)
                    print(response.request!)
                    print(error.localizedDescription)
                }
                
                
            }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapview.mapType = MKMapType.standard
        
        let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapview.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "current location"
        annotation.subtitle = "current location"
        mapview.addAnnotation(annotation)
        
        
        
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarkArray, error) in
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
            self.lbl_Address.text = address
          //  print(address)
        })

        }
        
        
        
    }
    
    

