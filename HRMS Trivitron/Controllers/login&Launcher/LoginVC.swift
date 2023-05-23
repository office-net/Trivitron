//
//  LoginVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 08/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController


class LoginVC: UIViewController {
    
  //  @IBOutlet weak var btn_sos: UIButton!
    @IBOutlet weak var btn_shareinfo: UIButton!

    @IBOutlet weak var txt_empcode: UITextField!
  
    @IBOutlet weak var txt_pass: UITextField!
    
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var mid_view: UIView!
    @IBOutlet weak var btnPasswordHideShow: UIButton!
    var isPasswordHide = true
    var deviceid = ""
    var deviceName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.layer.backgroundColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        self.mid_view.backgroundColor = UIColor.white
        mid_view.layer.shadowColor = UIColor.gray.cgColor
        mid_view.layer.shadowOpacity = 1
        mid_view.layer.shadowOffset = CGSize.zero
        mid_view.layer.shadowRadius = 3
//        self.navigationController?.navigationBar.barTintColor  = #colorLiteral(red: 0, green: 0.1882352941, blue: 0.368627451, alpha: 1)
//        self.navigationController?.navigationBar.backgroundColor  = #colorLiteral(red: 0, green: 0.1882352941, blue: 0.368627451, alpha: 1)
//        let label = UILabel()
//        label.textColor = #colorLiteral(red: 0.968627451, green: 0.5803921569, blue: 0.1137254902, alpha: 1)
//        label.font = UIFont.boldSystemFont(ofSize: 20.0)
//        
//        label.text = "LOGIN"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        
        let id  = UIDevice.current.identifierForVendor!.uuidString
        self.deviceid = id
        let name =  UIDevice.current.name
        
        self.deviceName = name
        print("============================================================================\(name)")
       
    }

    
    
    @IBAction func btn_ShareInfooo(_ sender: Any) {
        
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ShareInfoVC") as! ShareInfoVC
       
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        
        //  pvc.transitioningDelegate = self
        
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
        
        
        
    }
    
    @IBAction func btn_Soso(_ sender: Any) {
//        let options: [SemiModalOption : Any] = [
//            SemiModalOption.pushParentBack: false
//        ]
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let pvc = storyboard.instantiateViewController(withIdentifier: "SosSettingsVC") as! SosSettingsVC
//
//        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
//
//        pvc.modalPresentationStyle = .overCurrentContext
//
//        //  pvc.transitioningDelegate = self
//
//        presentSemiViewController(pvc, options: options, completion: {
//            print("Completed!")
//        }, dismissBlock: {
//        })
        
    }
    
    
    @IBAction func btn(_ sender: UIButton) {

        if txt_empcode.text == ""{
            self.showAlert(message: "Please enter emp code")
        }
        else if txt_pass.text == ""{
            self.showAlert(message: "Please enter Password")
        }
        else {

            SignApi()

        }
   
      //  SendToHome()
    }
    
    @IBAction func btn_hidepass(_ sender: Any) {
        if isPasswordHide{
            self.txt_pass.isSecureTextEntry = false
            isPasswordHide = false
            btnPasswordHideShow.setImage(UIImage(named: "showPassword"), for: .normal)
        }
        else {
            self.txt_pass.isSecureTextEntry = true
            isPasswordHide = true
            btnPasswordHideShow.setImage(UIImage(named: "hidePassword"), for: .normal)
        }
        
    }

    
    @IBAction func btn_ForgotPass(_ sender: Any) {
        if txt_empcode.text == ""{
            self.showAlert(message: "Please enter emp code")
        }
        else {
            forgotPass()
        }
        
    }
    func forgotPass()
    {
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserName":txt_empcode.text ?? "" ]
        
        
        
        AF.request(base.url+"ForgetPassword", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    DispatchQueue.main.async {
                        let  Message = json["Message"]
                        
                        self.showAlert(message:Message.stringValue )
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }}
    
 
    
    
    
    
    
    func SendToHome()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "HomeVC")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    func SignApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","Username":txt_empcode.text ?? "","password":self.txt_pass.text ?? "","deviceId":self.deviceid,"isLiveUser":"true","Additionaldeviceinformation":""]
        
        AF.request(base.url+"UserAuthentication", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result
                {
                
                case .success(let value):
                    let json2 = JSON(value)
                    let json = json2["UserDetailList"]
                    print(json2)
                    print(response.request!)
                    print(parameters)
                    let  status = json2["Status"].intValue
                    if status == 1 {
                        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
                        let Attendanceinput = json["AttendanceInput"].stringValue
                        UserDefaults.standard.set(Attendanceinput, forKey: "AttendanceInput")
                        
                        let UserID =  json["UserID"].intValue
                        print("==============================userId = \(UserID)")
                        UserDefaults.standard.set(UserID, forKey: "UserID")
                        
                        let TokenNo = json["TokenNo"].stringValue
                        print("==============================TokenNo = \(TokenNo)")
                        UserDefaults.standard.set(TokenNo, forKey: "TokenNo")
                        
                        let  Designation = json["Designation"].stringValue
                        UserDefaults.standard.set(Designation, forKey: "Designation") //setObject
                        
                        let  BloodGroup = json["BloodGroup"].stringValue
                        UserDefaults.standard.set(BloodGroup, forKey: "BloodGroup") //setObject
                        
                        let  UserName = json["Emp_First_name"].stringValue + " " + json["Emp_Middle_name"].stringValue + " " + json["Emp_Last_name"].stringValue
                        UserDefaults.standard.set(UserName, forKey: "UserName") //setObject
                        
                        let  EmployeeStatus = json["EmployeeStatus"].stringValue
                        UserDefaults.standard.set(EmployeeStatus, forKey: "EmployeeStatus") //EmployeeStatus
                        
                        let  Location = json["Location"].stringValue
                        UserDefaults.standard.set(Location, forKey: "Location") //EmployeeStatus
                        
                        
                        let  EmpCode = json["EmpCode"].stringValue
                        
                        UserDefaults.standard.set(EmpCode, forKey: "EmpCode") //EmployeeStatus
                        
                        
                        let  Gender = json["Gender"].stringValue
                        
                        UserDefaults.standard.set(Gender, forKey: "Gender") //EmployeeStatus
                        
                        let  Title = json["Title"].stringValue
                        
                        
                        UserDefaults.standard.set(Title, forKey: "Title") //EmployeeStatus
                        
                        let  PlantID = json["PlantID"].stringValue
                        
                        
                        UserDefaults.standard.set(PlantID, forKey: "PlantID") //EmployeeStatus
                        
                        let  ReportingManager = json["ReportingManager"].stringValue
                        
                        
                        UserDefaults.standard.set(ReportingManager, forKey: "ReportingManager") //EmployeeStatus
                        
                        let  MobileNo = json["MobileNo"].stringValue
                        
                        
                        UserDefaults.standard.set(MobileNo, forKey: "MobileNo") //EmployeeStatus
                        
                        
                        let  Message = json["Message"].stringValue
                        
                        
                        
                        UserDefaults.standard.set(Message, forKey: "Message") //EmployeeStatus
                        
                        let  Grade = json["Grade"].stringValue
                        
                        
                        UserDefaults.standard.set(Grade, forKey: "Grade") //EmployeeStatus
                        
                        
                        
                        
                        let  DateOfJoining = json["DateOfJoining"].stringValue
                        
                        
                        UserDefaults.standard.set(DateOfJoining, forKey: "DateOfJoining") //EmployeeStatus
                        
                        let  PlantName = json["PlantName"].stringValue
                        
                        
                        UserDefaults.standard.set(PlantName, forKey: "PlantName") //EmployeeStatus
                        
                        let  AttendanceInput = json["AttendanceInput"].stringValue
                        
                        
                        UserDefaults.standard.set(AttendanceInput, forKey: "AttendanceInput") //EmployeeStatus
                        
                        let  EmailID = json["EmailID"].stringValue
                        
                        
                        UserDefaults.standard.set(EmailID, forKey: "EmailID") //EmployeeStatus
                        
                        let  LocationCode = json["LocationCode"].stringValue
                        
                        
                        UserDefaults.standard.set(LocationCode, forKey: "LocationCode") //EmployeeStatus
                        
                        let  Status = json["Status"].stringValue
                        
                        
                        UserDefaults.standard.set(Status, forKey: "Status") //EmployeeStatus
                        
                        let  Department = json["Department"].stringValue
                        
                        
                        UserDefaults.standard.set(Department, forKey: "Department") //EmployeeStatus
                        
                        let  ImageURL = json["ImageURL"].stringValue
                        
                        UserDefaults.standard.set(ImageURL, forKey: "ImageURL") //EmployeeStatus
                        
                        
                        let  HeadOfDepartment = json["HeadOfDepartment"].stringValue
                        
                        
                        UserDefaults.standard.set(HeadOfDepartment, forKey: "HeadOfDepartment") //EmployeeStatus
                        
                        let  DateOfBirth = json["DateOfBirth"].stringValue
                        
                        UserDefaults.standard.set(DateOfBirth, forKey: "DateOfBirth") //EmployeeStatus
                        
                        UserDefaults.standard.set("True", forKey: "IsLogin") //setObject
                        
                        
                        DispatchQueue.main.async {
                            
                            
                            self.SendToHome()
                        }
                    }
                    else{
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        DispatchQueue.main.async {
                            let  Message = json2["Message"]
                            
                            self.showAlert(message:Message.stringValue )
                            
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
        
   
        
    }
    

    
    
    
    
    
}



extension UITextField {
    
    
    enum Direction2 {
        case Left
        case Right
    }
    func withImage2(direction: Direction, image: UIImage, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mainView.layer.cornerRadius = 5

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        

        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = #colorLiteral(red: 0, green: 0.2588235294, blue: 0.5058823529, alpha: 1)


        
        view.addSubview(imageView)
        if(Direction.Left == direction){ // image left

            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right

            self.rightViewMode = .always
            self.rightView = mainView
        }

        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
}

