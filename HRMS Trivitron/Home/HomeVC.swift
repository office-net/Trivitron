//
//  HomeVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 01/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import SPPermissions
import SemiModalViewController
import SDWebImage
import SideMenu
import RSSelectionMenu
protocol Birthday
{
    func btnBaddy(tag:Int)
}
protocol newjoiner
{
    func btnNewjoiner(tag:Int)
}

class HomeVC: UIViewController{
 
    
    var x = 1
    var imgaray:JSON = []
    var timer = Timer()
    var counter = 0
    var counter2 = 0
    var counter3 = 0
    var birthdayData:JSON = []
    var newjoineeData:JSON = []
    @IBOutlet weak var collectionViewNewJoine: UICollectionView!
    @IBOutlet weak var collectionViewBirthDay: UICollectionView!
    @IBOutlet weak var c2: NSLayoutConstraint!
    @IBOutlet weak var c1: NSLayoutConstraint!
    @IBOutlet weak var vv2_Hieght: NSLayoutConstraint!
    @IBOutlet weak var vv1_Hieght: NSLayoutConstraint!
  
    @IBOutlet weak var banner_Hieght: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var locationManager = CLLocationManager()

    @IBOutlet weak var lbl_NoBirthday: UILabel!
    @IBOutlet weak var lbl_NoNewJoinee: UILabel!
    
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    
    
   

    
    @IBOutlet weak var lbl_Intime: UILabel!
    @IBOutlet weak var lbl_OutTime: UILabel!
    
    
    @IBOutlet weak var lbl_inOut: UILabel!
    
    

    var lat = ""
    var long = ""
    var Address = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ProfileImage = UserDefaults.standard.object(forKey: "ImageURL") as? String {
            UserImage?.sd_setImage(with: URL(string:ProfileImage), placeholderImage: UIImage())
        }
       
        
        self.getUserLocation()
        UISetup()
        
        let when = DispatchTime.now() + 6
        DispatchQueue.main.asyncAfter(deadline: when) {
          
            self.getLocation()
        }
    }
    
    
    
    @IBAction func btn_All(_ sender: UIButton) {
        
        self.ShowAlertAutoDisable(message: "Coming Soon")
        
    }
    
    
    
    @IBAction func btn_PunchInOut(_ sender: Any) {
        self.MarkAttendance()
        
    }
    
    @IBAction func btn_Calender(_ sender: Any) {
        UserDefaults.standard.set("False", forKey: "MyTeam") //EmployeeStatus
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalenderViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        self.navigationController?.setNavigationBarHidden(false, animated: true)
          navigationController?.navigationBar.barStyle = .default
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.navigationBar.tintColor = UIColor.white
          self.navigationController?.view.backgroundColor = UIColor.clear
       self.navigationController?.navigationBar.backgroundColor = base.firstcolor
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
     
        getdetailsApi()
        
    }
    func maskCircle(anyImage: UIImageView) -> UIImageView {
        let img = anyImage
        img.contentMode = UIView.ContentMode.scaleAspectFill
        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = false
        img.clipsToBounds = true
        return img
        
    }
   

    
    
  
    
    
    
 
 
    
    
    
 

    
}


//==========================================================COLLECTION VIEW FOR BANNER===================================================

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    //MARK:-  Collection View Deleagete and DataSource 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView
        {
            return imgaray.count
        }
        if collectionView == self.collectionViewBirthDay
        {
            return birthdayData.arrayValue.count
            
        }
        else
        {
            
            return newjoineeData.arrayValue.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  self.collectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pagerCell", for: indexPath) as! pagerCell
            let dic =  self.imgaray[indexPath.row]["ImageURL"].stringValue
            cell.contentView.layer.cornerRadius = 2.0
            //self.imgProfile?.sd_setImage(with: URL(string:imgurl), placeholderImage: UIImage())
            cell.imgView?.sd_setImage(with: URL(string:dic), placeholderImage: UIImage())
            cell.imgView.contentMode = .scaleAspectFill
            cell.clipsToBounds = true
            return cell
        }
        else if collectionView ==  self.collectionViewBirthDay
                    
        {      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "birthdaycell", for: indexPath) as! birthdaycell
            cell.name.text =  birthdayData[indexPath.row]["EmpName"].stringValue
            cell.degination.text = birthdayData[indexPath.row]["EmpDesignation"].stringValue
            
            let imgpath = birthdayData[indexPath.row]["EmpImage"].stringValue
            // self.img_Profile?.sd_setImage(with: URL(string:imgpath), placeholderImage: UIImage())
            cell.img?.sd_setImage(with: URL(string:imgpath), placeholderImage: UIImage())
   
            return cell
            
        }
        else
        {   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newjoinehomecell", for: indexPath) as! newjoinehomecell
            
            
            
            cell.name.text =  newjoineeData[indexPath.row]["EmpName"].stringValue
            cell.degination.text = newjoineeData[indexPath.row]["EmpDesignation"].stringValue
            
            let imgpath = newjoineeData[indexPath.row]["EmpImage"].stringValue
            cell.img?.sd_setImage(with: URL(string:imgpath), placeholderImage: UIImage())
        
            return cell
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView ==  self.collectionViewBirthDay
        {
            self.btnBaddy(tag: indexPath.row)
        }
        else if collectionView ==  self.collectionViewNewJoine
        {
            self.btnNewjoiner(tag: indexPath.row)
        }
    }
    
}












//==================================================SERVICRE CALLS=================================================

extension HomeVC
{
    //================================================================================================================================
    
    
    func getdetailsApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":token!,"UserId":UserID,"VersionName":""]
        }
        Networkmanager.postRequest(vv: self.view, remainingUrl:"GetBannerImages", parameters: parameters!) { (response,data) in
            let json:JSON = response
            print(json)
            let status =  json["Status"].intValue
            if status == 1
            {
                let Attendanceinput = json["AttendanceInput"].stringValue
                UserDefaults.standard.set(Attendanceinput, forKey: "AttendanceInput")
                self.imgaray = json["SliderImageList"]
                self.pageControl.numberOfPages = self.imgaray.count
                self.pageControl.currentPage = 0
                self.lbl_Intime.text = json["InPunchTime"].stringValue
                self.lbl_OutTime.text = json["OutPunchTime"].stringValue
                let inOutstatus = json["IsPunch"].intValue
                let defaults = UserDefaults.standard

                 let Modules = json["Module"]
              //  UserDefaults.standard.set(Modules, forKey: "Modules")
                if let jsonString = Modules.rawString() {
                    // Save the string value in UserDefaults
                    UserDefaults.standard.set(jsonString, forKey: "Modules")
                }
                
                if inOutstatus == 1
                {
                    self.lbl_inOut.text = "Punch Out"
                    
                }
                else
                {
                    self.lbl_inOut.text = "Punch In"
       
                  
                }
            
                if json["InPunchTime"].stringValue == "" || json["OutPunchTime"].stringValue != ""
                {
                    defaults.set(false, forKey: "IsLocationUpdate")
                }
                else
                {
                    defaults.set(true, forKey: "IsLocationUpdate")
                }
                
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                self.collectionView.reloadData()
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
            }
            else
            {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
        
    }
    @objc func changeImage() {
        
        if counter < imgaray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
        
    }
}



















class pagerCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
}
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension HomeVC
{
    func birthdayAPI()
    {   CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
     
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HRCorner_GetList", parameters: parameters!) { (response,data) in
            let json:JSON = response
           // print(json)
            let status =  json["Status"].intValue
            if status == 1
            { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                self.birthdayData = json["EmpBirthdayList"]
                if self.birthdayData.isEmpty
                {
                   
                    self.collectionViewBirthDay.isHidden = true
                       self.c1.constant = 0
                       self.vv1_Hieght.constant = 60
                }
                else
                {
                    print(self.birthdayData)
                    self.collectionViewBirthDay.reloadData()
                    
                    self.timer = Timer.scheduledTimer(timeInterval:3, target: self, selector: #selector(self.changeImage2), userInfo: nil, repeats: true)
                }
               
              
            }
            else
            {   self.collectionViewBirthDay.isHidden = true
                self.c1.constant = 0
                self.vv1_Hieght.constant = 60
            }
        }
        
    }
    @objc func changeImage2() {
        if birthdayData.count < 1
        {
            c1.constant = 60
        }
        else
        {
            
            if counter2 < birthdayData.count {
                let index = IndexPath.init(item: counter2, section: 0)
                self.collectionViewBirthDay.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                // pageControl.currentPage = counter
                counter2 += 1
            } else {
                counter2 = 0
                let index = IndexPath.init(item: counter2, section: 0)
                self.collectionViewBirthDay.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                //pageControl.currentPage = counter
                counter2 = 1
            }
        }
    }
    //=====================================================================================
    
    func NewJoineeAPI()
    {   CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?

        parameters = ["TokenNo":"abcHkl7900@8Uyhkj"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"HRCorner_GetList", parameters: parameters!) {
            (response,data) in
            let json:JSON = response
          //  print(json)
            let status =  json["Status"].intValue
            if status == 1
            { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                self.newjoineeData = json["EmpNewJoiningList"]
                
                if self.newjoineeData.isEmpty
                {
                    print(self.newjoineeData)
                    self.collectionViewNewJoine.isHidden = true
                      self.vv2_Hieght.constant = 60
                      self.c2.constant = 0
                }
                else
                {
                    self.collectionViewNewJoine.reloadData()
                
                    self.timer = Timer.scheduledTimer(timeInterval:2.5, target: self, selector: #selector(self.changeImage3), userInfo: nil, repeats: true)
                }
              
                
            }
            else
            {   self.collectionViewNewJoine.isHidden = true
                self.vv2_Hieght.constant = 60
                self.c2.constant = 0
            }
        }
        
        
    }
    @objc func changeImage3() {
        if newjoineeData.count == 1
        {
            c2.constant = 60
        }
        else
        {
            if counter3 < newjoineeData.count {
                let index = IndexPath.init(item: counter3, section: 0)
                self.collectionViewNewJoine.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                // pageControl.currentPage = counter
                counter3 += 1
            } else {
                counter3 = 0
                let index = IndexPath.init(item: counter3, section: 0)
                self.collectionViewNewJoine.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                //pageControl.currentPage = counter
                counter3 = 1
            }
            
        }
        
    }
    
    //========================================================================================================
    func btnNewjoiner(tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "BirthdayWishVC") as! BirthdayWishVC
        pvc.txtname = newjoineeData[tag]["EmpName"].stringValue
        pvc.imgpath = newjoineeData[tag]["EmpImage"].stringValue
        pvc.empcode = newjoineeData[tag]["EmpID"].stringValue
        pvc.strWishType = "NewJoinee"
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }
    
}







class birthdaycell:UICollectionViewCell
{

    @IBOutlet weak var vv: UIView!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var degination: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      
    
    }
}
class newjoinehomecell:UICollectionViewCell
{
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var degination: UILabel!
    @IBOutlet weak var img: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    
    
    
    
    
    
    
    
}

extension HomeVC
{
    func btnBaddy(tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "BirthdayWishVC") as! BirthdayWishVC
        pvc.txtname = birthdayData[tag]["EmpName"].stringValue
        pvc.imgpath = birthdayData[tag]["EmpImage"].stringValue
        pvc.empcode = birthdayData[tag]["EmpID"].stringValue
        pvc.strWishType = "Birthday"
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }
}





extension HomeVC
{
    
    
    func MarkAttendance()
    {     let screenSize = UIScreen.main.bounds
        
        let smeiViewHieght = (screenSize.height/4) * 3
         
        let AttendanceInput = UserDefaults.standard.object(forKey: "AttendanceInput") as? String
        if AttendanceInput == "A"
        {
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "MarkAttendanceVC") as! MarkAttendanceVC
            
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: smeiViewHieght)
            
            pvc.modalPresentationStyle = .overCurrentContext
            pvc.delegate = self
            
            presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
        }
        else
        {
            showAlert(message: "You Are not Allowed to Mark Attendance")
        }
    }

    
    
  
 

}





//=================================================================SETUP SIDE MENU===============================================



extension HomeVC:Birthday,newjoiner, reloadData
{
    func ab() {
        print("============================================================= (Hello from MarkAttendance)")
 
        getdetailsApi()
    }
    
    func UISetup()
    {
        
//        btnpunch.isHidden = true
        let screenSize = UIScreen.main.bounds
        
        self.banner_Hieght.constant = screenSize.height/5
        
        //=========================PAGER CONTROL=======
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = base.firstcolor //==================================================================
        
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        
        let userName = UserDefaults.standard.object(forKey: "UserName") as? String
        lbl_UserName.text = userName
      
        birthdayAPI()
        NewJoineeAPI()
        
    
    }
    
    
    func setpermissions()
    {
        let controoler = SPPermissions.list([.camera,.locationAlwaysAndWhenInUse])
        controoler.titleText = "Trivitron"
        controoler.headerText = "Please allow permissions to get started"
        controoler.footerText = "These Are Required"
        controoler.present(on: self)
    }
    
 
    
    private func setupSideMenu() {
        
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
}









//====================================Get User location 1 time =============================================================



extension HomeVC:CLLocationManagerDelegate
{
    @objc func getLocation()
    {
        let defaults = UserDefaults.standard

        let data = defaults.object(forKey: "IsLocationUpdate") as? Bool
//
        if data == true
        {
            ApiCallingTrackLocation(lat: self.lat, long: self.long, Address: self.Address)
        }
        

    }


    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.lat = "\(location.coordinate.latitude)"
            self.long = "\(location.coordinate.longitude)"

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
