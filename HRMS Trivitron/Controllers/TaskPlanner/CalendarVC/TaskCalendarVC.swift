//  TaskCalendarVC.swift
//  NewOffNet
//  Created by Netcommlabs on 11/07/22.

import UIKit
import SwiftyJSON
import FSCalendar
import CoreLocation

protocol ViewDetailsTask: AnyObject
{
    func ButtonPressed(IndexPath:Int)
}
protocol GoMeetingButton:AnyObject
{
    func gomeetingButton(index:Int)
}
protocol TravelBackButon:AnyObject
{
    func travelbackButton(index:Int)
}
protocol EndTaskButton:AnyObject
{
    func EnsTaskButton(index:Int)
}
protocol MarkVisitButton:AnyObject
{
    func MarkVisiyButton(index:Int)
}
class TaskCalendarVC: UIViewController, FSCalendarDelegate {
    
    
    
    
    var AdditionamDish = [[String:Any]]()
    var CompetitorDish = [[String:Any]]()
    
    var locationManager:CLLocationManager!
    var currentAddress = ""
    var lat = ""
    var long = ""
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var cc: FSCalendar!
    
  
    
    var GetData:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        cc.delegate = self
        self.title = "Task Planner"
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(sayHello), userInfo: nil, repeats: true)
    }
    @objc func sayHello()
    {

      //  ApiCallingTrackLocation()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApiCalling(Fromdate: Date.getCurrentDate())
        determineMyCurrentLocation()
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let string = formatter.string(from: date)
        print("\(string)")
        ApiCalling(Fromdate: string)
    }
    
   
    
    
    
    
}





//====================================================Protocal Delegates===================================================
extension TaskCalendarVC:GoMeetingButton,ViewDetailsTask,TravelBackButon,EndTaskButton,MarkVisitButton
{
    func MarkVisiyButton(index: Int) {
       
        let taskid = GetData["TaskList"][index]["TaskId"].stringValue
        let RowNo = IndexPath(row: index, section: 0)
        let cell: CalenderTaskCell = self.tbl.cellForRow(at: RowNo) as! CalenderTaskCell
        let ab = cell.Btn_MarkVisit.titleLabel?.text
       // print(ab!)
        if ab == "Mark Visit"
        {
            self.ApiCallingForMarkVisit(TaskId: taskid)
        }
        else
        {
            let ab = GetData["TaskList"][index]
           
            SubmitAPICalling(PERSON_NAME: ab["ContactPerson"].stringValue, TaskId: ab["TaskId"].stringValue, ContactNo: ab["CONTACT_NO"].stringValue, CompanyName: ab["COMPANY_NAME"].stringValue)
        }

       
      
        

    }
    
    func EnsTaskButton(index: Int) {
        let taskid = GetData["TaskList"][index]["TaskId"].stringValue
        ApiCallingForButtons(Type: "endTask", TaskId: taskid)
    }
    
    func travelbackButton(index: Int) {
        let taskid = GetData["TaskList"][index]["TaskId"].stringValue
        ApiCallingForButtons(Type: "travelBack", TaskId: taskid)
    }
    
    func gomeetingButton(index: Int) {
        let taskid = GetData["TaskList"][index]["TaskId"].stringValue
        ApiCallingForButtons(Type: "goToMeeeting", TaskId: taskid)
    }
    func ButtonPressed(IndexPath: Int) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TasKDetailsVC")as! TasKDetailsVC
        vc.getdata = self.GetData["TaskList"][IndexPath]
        vc.ADDITIONAL_PERSON = self.GetData["TaskList"][IndexPath]["ADDITIONAL_PERSON"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//===============================================================ENDDD======================================================






extension TaskCalendarVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return GetData["TaskList"].count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalenderTaskCell", for: indexPath) as! CalenderTaskCell
        cell.lbl_name.text = GetData["TaskList"][indexPath.row]["CUSTOMER_NAME"].stringValue
        let startdate = GetData["TaskList"][indexPath.row]["STARTS_DATE"].stringValue
        let startTime = GetData["TaskList"][indexPath.row]["START_TIME"].stringValue
        let Enddate = GetData["TaskList"][indexPath.row]["END_DATE"].stringValue
        let EndTime = GetData["TaskList"][indexPath.row]["END_TIME"].stringValue
       
        let enddateTime = Enddate + " " + EndTime
        
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd/MM/yyyy' 'HH:mm:ss"
        let stringDate = timeFormatter.string(from: time)
        
        let firstDateFormatter = DateFormatter()
        firstDateFormatter.dateFormat = "dd/MM/yyyy' 'HH:mm:ss"
        if let date1 = firstDateFormatter.date(from: stringDate),
              let date2 = firstDateFormatter.date(from: enddateTime)
        {
            if date1 > date2
            {
              
                cell.Btn_MarkVisit.setTitle("Mark M Over", for: .normal)
            }
            else
            {   let MarkVisit = GetData["TaskList"][indexPath.row]["MarkVisit"].stringValue
                if MarkVisit == "Y"
                {
                    cell.Btn_MarkVisit.setTitle("Mark M Over", for: .normal)
                }
                else
                {
                    cell.Btn_MarkVisit.setTitle("Mark Visit", for: .normal)
                }
                
               
            }
        }
        
        
        
        
        let newstrTime = String(startTime.prefix(5))
        let ebdstrTime = String(EndTime.prefix(5))
        cell.lbl_DateAndTime.text = ("\(startdate) \(newstrTime) - \(Enddate) \(ebdstrTime)")
        cell.BtnViewDetails.tag = indexPath.row
        cell.delegate = self
        cell.GoMeetingDelegate = self
        cell.btn_goomeetings.tag = indexPath.row
        cell.travelbackDelefate = self
        cell.BtnTravelBack.tag = indexPath.row
        cell.endTaskDelegate = self
        cell.BtnEndTask.tag = indexPath.row
        cell.markVisitDelegate = self
        cell.Btn_MarkVisit.tag = indexPath.row
        
        let trabalback = GetData["TaskList"][indexPath.row]["travelLocation"].stringValue
        if trabalback == ""
        {
            cell.BtnTravelBack.isHidden = false
            cell.vv_TravelBack.isHidden = false
        }
        else
        {
            cell.BtnTravelBack.isHidden = true
            cell.vv_TravelBack.isHidden = true
        }
        
        let endTask = GetData["TaskList"][indexPath.row]["taskEndLocation"].stringValue
        if endTask == ""
        {
            cell.BtnEndTask.isHidden = false
            cell.vv_endTask.isHidden = false
        }
        else
        {
            cell.BtnEndTask.isHidden = true
            cell.vv_endTask.isHidden = true
        }
        let Gomeetingbutton = GetData["TaskList"][indexPath.row]["Gomeetingbutton"].intValue
        if Gomeetingbutton == 0
        {
            cell.btn_goomeetings.isHidden = false
            cell.vv_Gotomeeting.isHidden = false
        }
        else
        {
            cell.btn_goomeetings.isHidden = true
            cell.vv_Gotomeeting.isHidden = true
        }
        
        
        
        let MarkMeetingOver = GetData["TaskList"][indexPath.row]["MarkMeetingOver"].intValue
        let PrimaryTask = GetData["TaskList"][indexPath.row]["MarkMeetingOver"].intValue
        let TaskAssigned = GetData["TaskList"][indexPath.row]["TaskAssigned"].intValue
        if (MarkMeetingOver != 0) || (PrimaryTask != 0) && (TaskAssigned != 0)
        {
            cell.Btn_MarkVisit.isHidden = true
            cell.vv_MatkVisit.isHidden = true
        }
        else
        {
            cell.Btn_MarkVisit.isHidden = false
            cell.vv_MatkVisit.isHidden = false
        }
        //Gomeetingbutton
        
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    func setupTableView()
    {
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        tbl.register(UINib(nibName: "CalenderTaskCell", bundle: nil), forCellReuseIdentifier: "CalenderTaskCell")
        
    }
    
}




extension TaskCalendarVC
{
    func ApiCalling(Fromdate:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"Fromdate":Fromdate,"TaskId":"","Todate":Fromdate] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"TaskList", parameters: parameters) { (response,data) in
            self.GetData = response
            let status = self.GetData["Status"].intValue
            if status == 1
            {
                print(self.GetData)
                self.tbl.reloadData()
                
            }
            else
            {
                let msg = self.GetData["Message"].stringValue
                self.showAlert(message: msg)
                self.tbl.reloadData()
            }
        }
    }
    
    
    func ApiCallingForButtons(Type:String,TaskId:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskId,"Address":self.currentAddress,"Gotime":base.getCurrentTime(),"Latitude":self.lat,"Longitude":self.long,"MeetingType":Type] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"EmpVisitGoing", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.ApiCalling(Fromdate: Date.getCurrentDate())
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    func ApiCallingForMarkVisit(TaskId:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskId,"Address":self.currentAddress,"Gotime":base.getCurrentTime(),"Latitude":self.lat,"Longitude":self.long] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"MarkVisit", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.ApiCalling(Fromdate: Date.getCurrentDate())
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
    
    
    
    
    
    
}



extension TaskCalendarVC:CLLocationManagerDelegate
{
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.lat = "\(userLocation.coordinate.latitude)"
        self.long = "\(userLocation.coordinate.longitude)"
        
        //self.getAddressFromLatLon(pdblLatitude: "\(userLocation.coordinate.latitude)", withLongitude: "\(userLocation.coordinate.longitude)")
        let myLocation : CLLocation = locations[0]
        manager.stopUpdatingLocation()  // use this line only if 1 location is needed.
        
        CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler:{(placemarks, error) in
            
            if ((error) != nil)  { print("Error: \(String(describing: error))") }
            else {
                
                let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
                
                var subThoroughfare:String = ""
                var thoroughfare:String = ""
                var subLocality:String = ""
                var subAdministrativeArea:String = ""
                var postalCode:String = ""
                var country:String = ""
                
                    // Use a series of ifs, or nil coalescing operators ??s, as per your coding preference.
                    
                if ((p.subThoroughfare) != nil) {
                    subThoroughfare = (p.subThoroughfare)!
                }
                if ((p.thoroughfare) != nil) {
                    thoroughfare = p.thoroughfare!
                }
                if ((p.subLocality) != nil) {
                    subLocality = p.subLocality!
                }
                if ((p.subAdministrativeArea) != nil) {
                    subAdministrativeArea = p.subAdministrativeArea!
                }
                if ((p.postalCode) != nil) {
                    postalCode = p.postalCode!
                }
                
                if ((p.country) != nil) {
                    country = p.country!
                }
                self.currentAddress =  "\(subThoroughfare) \(thoroughfare)  \(subLocality) \(subAdministrativeArea) \(postalCode)\(country)"
                print(self.currentAddress)
            }   // end else no error
          }       // end CLGeocoder reverseGeocodeLocation
        )       // end CLGeocoder
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                var addressString : String = ""
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.subThoroughfare != nil {
                    addressString = addressString + pm.subThoroughfare! + ", "
                }
                
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.administrativeArea != nil {
                    addressString = addressString + pm.administrativeArea! + ", "
                }
                if pm.subAdministrativeArea != nil {
                    addressString = addressString + pm.subAdministrativeArea! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                
                self.currentAddress = addressString
            }
        })
        

    }
    // end of loc
//    func ApiCallingTrackLocation()
//    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
//        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
//        let parameters = ["TokenNo":token!,"UserId":UserID!,"LocationArrList":[["LocationID":0,"Latitude":self.lat,"Longitude":self.long,"Timestamp":"","AccuracyMeters":"100","Address":self.currentAddress]] ]as [String : Any]
//        Networkmanager.postRequest(vv: self.view, remainingUrl:"TrackedUserLocations", parameters: parameters) { (response,data) in
//            let json:JSON = response
//            let status = json["Status"].intValue
//            if status == 1
//            {
//            print(json)
//            }
//
//        }
//    }
    func SubmitAPICalling(PERSON_NAME:String,TaskId:String,ContactNo:String,CompanyName:String)
    {

        
        
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let params:[String:Any] = ["TokenNo":token!,"UserId":UserID!,"TaskId":TaskId,"CompanyName":CompanyName,"PERSON_NAME":PERSON_NAME,"ContactNo":ContactNo,"ReasonOfVisit":"","ImageExtension":"png","markMeetingOver":true,"ADDITIONAL_PERSON":"","CompetitorDetail":"","CVRDetails":["DESIGNATION": "S", "CLIENT_INFORMATION": "", "BRANCH": "HO", "CUSTOMER_TYPE": "E", "TYPE_OF_VISIT": "", "REMARKS": "", "EMP_CODE": "", "ACTION_REQ": "", "CONTACT_NO": "", "OtherProduct": "", "PERSON_NAME": "", "EMP_NAME": "", "REASON_OF_VISIT": "", "CATE_OF_INTEREST": "", "LOCATION":"", "STATE_NAME": "", "EMAIL_ID": "", "DATE_OF_VISIT": "", "TIME_OF_VISIT": "", "CITY_NAME": "", "CUSTOMER_NAME": "", "OUTCOME_OF_VISIT": "", "PROD_OF_INTEREST": ""],"Userselfieimage":""]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"MarkMeetingover", parameters: params) { (response,data) in
            let json = response
            let status = json["Status"].intValue
            if status == 1
            {
                print(json)
                let msg = json["Message"].stringValue
                // Create the alert controller
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
      
    }
}

extension TaskCalendarVC
{
    func markvisitButtonSetup()
    {
        print(Date.getCurrentDate())
    }
}






 
