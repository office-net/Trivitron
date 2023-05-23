//  profileVC.swift
//  NewOffNet
//  Created by Netcomm Labs on 30/09/21.


import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage

class profileVC: UIViewController {
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var titleContactDetails: UILabel!
    
    @IBOutlet weak var titleOtherDetails: UILabel!
    @IBOutlet weak var titleEmployeDetails: UILabel!
    @IBOutlet weak var titleEmpName: UILabel!
    @IBOutlet weak var hName: UILabel!
    @IBOutlet weak var hBooldGroup: UILabel!
    @IBOutlet weak var hLocation: UILabel!
    @IBOutlet weak var hindiGender: UILabel!
    @IBOutlet weak var hindi_DateOfBirth: UILabel!
    
    @IBOutlet weak var hNumber: UILabel!
    @IBOutlet weak var h_HOD: UILabel!
    @IBOutlet weak var hRM: UILabel!
  
    @IBOutlet weak var hEmployeCode: UILabel!
    @IBOutlet weak var hDOJ: UILabel!
    @IBOutlet weak var hEmail: UILabel!
    
    
    
    
    
    
    
    @IBOutlet weak var Profile_img: UIImageView!
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btn_uploadProfile: UIButton!
    
    @IBOutlet weak var Desigination: UILabel!
    
    @IBOutlet weak var lblEmpStatus: UILabel!
    
    @IBOutlet weak var lbl_Gendar: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblHOd: UILabel!
    @IBOutlet weak var lblReportingManger: UILabel!
    
    @IBOutlet weak var seg: UISegmentedControl!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    @IBOutlet weak var lblEmpCode: UILabel!
    @IBOutlet weak var dateOfJoining: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_blodgroup: UILabel!
    var imgString = ""
    
    
    
    //++++++++++++++++++++++++++++Hindi lable++++++++++++++++++++++++++
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
        if Language == "English"
            {
            self.Translate(index: 0)
        }
            else
            {
                self.Translate(index: 1)
            }
        }
        
  
   
        
        
        maskCircle(anyImage: Profile_img)
        btn_uploadProfile.contentMode = UIView.ContentMode.scaleAspectFill
        btn_uploadProfile.layer.cornerRadius = btn_uploadProfile.frame.height / 2
        btn_uploadProfile.layer.masksToBounds = false
        btn_uploadProfile.clipsToBounds = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(selectorMethod))
        
    }
    @objc func selectorMethod() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        // CALL API
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .default
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = base.firstcolor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        profileDataApi()
    }
    
    
    func maskCircle(anyImage: UIImageView){
        let img = anyImage
        img.contentMode = UIView.ContentMode.scaleAspectFill
        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = false
        img.clipsToBounds = true
        
        
    }
    
    @IBAction func btnSeg(_ sender: Any) {
        
        if seg.selectedSegmentIndex == 0
        {
            self.Translate(index: 0)
        
        }
        else
        {
            self.Translate(index: 1)
        
        }
    }
    
    @IBAction func btn_ChangePassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC")as! ChangePasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
        
        
    }
    
    
   
    
    
    @IBAction func btn_uploadprofile(_ sender: Any) {
        
        
        callImagePicker()
    }
    
    
    
    func MyPage_UpdateProfilePicAPI()  {
        let EmpCode = UserDefaults.standard.object(forKey: "EmpCode") as? String
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"EmpCode":EmpCode ?? "","FileInBase64":imgString, "FileExt":".png"]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }
        Networkmanager.postRequest(vv: self.view, remainingUrl:"MyPage_UpdateProfilePic", parameters: parameters!) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1 {
                
                let ImagePath =  response["ImagePath"].stringValue
                UserDefaults.standard.set(ImagePath, forKey: "ImageURL")
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)
                
            }else {
                
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)}}
        
    }
    
}
    
    class GradientView: UIView {
        override open class var layerClass: AnyClass {
            return CAGradientLayer.classForCoder()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            let color1 = base.firstcolor
            let color2 = base.secondcolor
            gradientLayer.colors = [color1.cgColor,color2.cgColor]
        }
        
    }
    
    
    
    extension profileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.4)
                
                self.Profile_img.image = imagePicked
                
                imgString = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
                
                MyPage_UpdateProfilePicAPI()
                
                
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
        func callImagePicker() {
            
            let imagePicker=UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            let optionMenu = UIAlertController(title : nil , message: "Choose preferred source type", preferredStyle: UIAlertController.Style.actionSheet)
            let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
                
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            optionMenu.addAction(camera)
            optionMenu.addAction(UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default, handler: { action in
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
                
            }))
            optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                action in
                optionMenu.dismiss(animated: true, completion: nil)}))
            self.present(optionMenu, animated: true, completion: nil)
        }
        
        
    }
    
    extension profileVC
    {
        func profileDataApi()
        {   let parameters:[String:Any]
            let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
            parameters = ["UID": UserID!, "TokenNo": "abcHkl7900@8Uyhkj"]
            Networkmanager.postRequest(vv: self.view, remainingUrl:"UpdateEmpProfile", parameters: parameters) { (response,data) in
                print(response)
                self.lbl_blodgroup.text = response["BloodGroup"].stringValue
                self.name.text = response["UserName"].stringValue
                self.lblName.text = response["UserName"].stringValue
                self.lblEmpCode.text = response["EmpCode"].stringValue
                self.lblEmailID.text = response["EmailID"].stringValue
                self.lblMobileNumber.text = response["MobileNo"].stringValue
                self.Desigination.text = response["Designation"].stringValue
                self.lblReportingManger.text =  response["ReportingManager"].stringValue
                self.lblHOd.text =  response["HeadOfDepartment"].stringValue
                self.lblLocation.text = response["Location"].stringValue
                self.lbl_Gendar.text = response["Grade"].stringValue
                self.lblEmpStatus.text = response["EmployeeStatus"].stringValue
                self.dateOfJoining.text = response["DateOfJoining"].stringValue
                self.lblDOB.text = response["DateOfBirth"].stringValue
                let ImageURL = response["ImageURL"].stringValue
                self.Profile_img?.sd_setImage(with: URL(string:ImageURL), placeholderImage: UIImage())
            }
        }
    }


extension String
{
    func localizableString(loc:String) -> String
    {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundel = Bundle(path: path!)
        return NSLocalizedString(self,tableName: nil,bundle: bundel!,value: "",comment: "")
    }
}


extension profileVC
{
    func Translate(index:Int)
    {
        let defaults = UserDefaults.standard
       
        if index == 0
        {    defaults.set("English", forKey: "Language")
            self.seg.selectedSegmentIndex = 0
          //"EmployeeDetails " = "Employee Details" ;
            self.hindi_DateOfBirth.text = "DOB".localizableString(loc: "en")
            self.hEmployeCode.text = "EmployeCode".localizableString(loc: "en")
            self.hRM.text = "ReportingManager".localizableString(loc: "en")
            self.h_HOD.text = "HOD".localizableString(loc: "en")
            self.hDOJ.text = "DOJ".localizableString(loc: "en")
            self.hEmail.text = "EmailId".localizableString(loc: "en")
            self.hNumber.text = "MobileNumber".localizableString(loc: "en")
            self.hLocation.text = "Location".localizableString(loc: "en")
            self.titleEmpName.text = "EmployeeName".localizableString(loc: "en")
            self.hName.text = "EmployeeName".localizableString(loc: "en")
            self.titleEmployeDetails.text = "EmployeeDetails".localizableString(loc: "en")
            self.title = "Profile".localizableString(loc: "en")
            self.hindiGender.text = "Gender".localizableString(loc: "en")
            self.titleContactDetails.text = "ContactDetails".localizableString(loc: "en")
            self.hBooldGroup.text = "BloodGroup".localizableString(loc: "en")
            self.titleOtherDetails.text = "OtherDetails".localizableString(loc: "en")
            
            //OtherDetails
        }
        else
        {
            defaults.set("Hindi", forKey: "Language")
            self.seg.selectedSegmentIndex = 1
            self.hindi_DateOfBirth.text = "DOB".localizableString(loc: "hi")
            self.hEmployeCode.text = "EmployeCode".localizableString(loc: "hi")
            self.hRM.text = "ReportingManager".localizableString(loc: "hi")
            self.h_HOD.text = "HOD".localizableString(loc: "hi")
            self.hDOJ.text = "DOJ".localizableString(loc: "hi")
            self.hEmail.text = "EmailId".localizableString(loc: "hi")
            self.hNumber.text = "MobileNumber".localizableString(loc: "hi")
            self.hLocation.text = "Location".localizableString(loc: "hi")
            self.titleEmpName.text = "EmployeeName".localizableString(loc: "hi")
            self.hName.text = "EmployeeName".localizableString(loc: "hi")
            self.titleEmployeDetails.text = "EmployeeDetails".localizableString(loc: "hi")
            self.title = "Profile".localizableString(loc: "hi")
            self.hindiGender.text = "Gender".localizableString(loc: "hi")
            self.titleContactDetails.text = "ContactDetails".localizableString(loc: "hi")
            self.hBooldGroup.text = "BloodGroup".localizableString(loc: "hi")
            self.titleOtherDetails.text = "OtherDetails".localizableString(loc: "hi")
        }
    }
}
