//
//  CODetailsVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 28/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreMedia


class CODetailsVC: UIViewController {
    
    var dodo:JSON = []
    var json:JSON = []
    
    var IsFirstApprovalDetailsVisable = 0
    var IsApprovalbuttonVisable = 0
    
    var isFromCancelVC = false
    var isFromPendingVC = false
    var cancelbtn = 0
    var approvebtn = 0
    var disapprovebtn = 0
    
    @IBOutlet weak var hieghtRemarks: NSLayoutConstraint!
    @IBOutlet weak var Hieght_Stck: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbl_department: UILabel!
    @IBOutlet weak var lbl_Empcode: UILabel!
    @IBOutlet weak var lblDesigination: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRequestNO: UILabel!
    @IBOutlet weak var lblSubbmitDate: UILabel!
    @IBOutlet weak var lblMOBO: UILabel!
    @IBOutlet weak var lbl_LeaveType: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!

    @IBOutlet weak var lbl_SubbmitedBY: UILabel!
    @IBOutlet weak var lbl_Purpose: UILabel!
    @IBOutlet weak var midview: UIView!
    
    
    @IBOutlet weak var Mid_View_Hight: NSLayoutConstraint!
    @IBOutlet weak var txt_Remark: UITextField!
    @IBOutlet weak var btn_Approve: UIButton!
    @IBOutlet weak var btn_DisApprove: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    
    @IBOutlet weak var RMStatus: UILabel!
    
    @IBOutlet weak var RMRemarks: UILabel!
    
  
    @IBOutlet weak var lbl_HRstatus: UILabel!
    @IBOutlet weak var lbl_HRremark: UILabel!
    
    
    
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var empcode: UILabel!
    @IBOutlet weak var department: UILabel!
    @IBOutlet weak var desigination: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var requestDetails: UILabel!
    @IBOutlet weak var requestnumber: UILabel!
    @IBOutlet weak var submitdate: UILabel!
    @IBOutlet weak var leavetype: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var numberofdays: UILabel!
    @IBOutlet weak var submitBy: UILabel!
    @IBOutlet weak var puspose: UILabel!
    @IBOutlet weak var reporintmanager: UILabel!
    @IBOutlet weak var RMremarks: UILabel!
    

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagechange()
        self.midview.layer.borderWidth = 1
        self.midview.layer.borderColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        txt_Remark.isHidden = true
        
        detailsVCAPI()
     
        
        //detailAPI()
        //  print("------------\(self.dodo["RMStatus"])")
        // Do any additional setup after loading
    }
    func detailsVCAPI()
    {  CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue ,"Type":self.dodo["Type"].stringValue]
       // print(parameters)
        AF.request( base.url+"CompOff_ViewRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters)
                switch response.result
                {
                    
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    self.json = JSON(Value)
                    print(self.json)
                    self.lblName.text = self.json["EmpName"].stringValue
                    self.lbl_Empcode.text = self.json["EmpCode"].stringValue
                    self.lbl_department.text = self.json["EmpDepartment"].stringValue
                    self.lblDesigination.text = self.json["EmpDesignation"].stringValue
                    self.lblAddress.text = self.json["EmpLocation"].stringValue
                    self.lblRequestNO.text = self.json["ReqNo"].stringValue
                    self.lblSubbmitDate.text = self.dodo["RequestDate"].stringValue
                    self.lbl_FromDate.text = self.json["CompOffDate"].stringValue
                    self.lbl_ToDate.text = self.json["CompOffDate"].stringValue
                    self.lbl_LeaveType.text = self.json["NoOfDays"].stringValue
                    self.RMStatus.text = self.json["RMStatus"].stringValue
                    self.RMRemarks.text = self.json["RMRemarks"].stringValue
                    self.lbl_HRstatus.text = self.json["HODName"].stringValue
                    self.lbl_HRremark.text = self.json["HODRemarks"].stringValue
                    self.cancelbtn = self.json["IsCancelButtonVisable"].intValue
                    self.approvebtn = self.json["IsApprovalButtonVisable"].intValue
                
                    self.disapprovebtn = self.json["IsCancelButtonVisable"].intValue
                    
                    
                    self.lbl_Purpose.text = self.json["Purpose"].stringValue
                    //  ----------------------CANCEL BTN ----------------------
                    if self.cancelbtn == 1
                    {
                        self.btn_Cancel.isHidden = false
                        self.txt_Remark.isHidden = false
                        self.Hieght_Stck.constant = 0
                    }
                    else
                    {
                        self.btn_Cancel.isHidden = true
                        self.Hieght_Stck.constant = 45
                    }
                    //-------------------APPROVE BTN-----------------------------------
                    if self.approvebtn == 1
                    {
                        self.btn_Approve.isHidden = false
                        self.btn_DisApprove.isHidden = false
                        self.txt_Remark.isHidden = false
                    }
                    else
                    {
                        self.btn_Approve.isHidden = true
                        self.btn_DisApprove.isHidden = true
                        
                    }
                  
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
            }
    }
    
    
    func cancelAPI()
    { CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":self.dodo["ReqNo"].stringValue,"ReqID": self.dodo["ReqID"].stringValue,"UserID":UserID,"Remarks":"Cancel","Type":self.dodo["Type"].stringValue]
        }
        else {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":self.dodo["ReqNo"].stringValue]
        }
        AF.request( base.url+"CompOff_Cancel", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(Value)
                    print(json)
                    let status = json["Status"].intValue
                    if status == 1 {
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
                
                
                
            }
    }
    
    func ApproveAPI()
    {CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue,"UserID":UserID,"Remarks":txt_Remark.text ?? "","Type":self.dodo["Type"].stringValue,"ReqNo":self.json["ReqNo"].stringValue]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue]
        }
        AF.request( base.url+"CompOff_Approve", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(Value)
                    print(json)
                    
                    let status = json["Status"].intValue
                    if status == 1 {
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else {
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
        
    }
    func DisApproveAPI()
    {CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue,"UserID":UserID,"Remarks":txt_Remark.text ?? "","Type":self.dodo["Type"].stringValue,"ReqNo":self.json["ReqNo"].stringValue]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":self.dodo["ReqID"].stringValue]
        }
        AF.request( base.url+"CompOff_Disapprove", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                
                case .success(let Value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(Value)
                    print(json)
                    
                    let status = json["Status"].intValue
                    if status == 1 {
                        let Message = json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else {
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
        
    }
    
    @IBAction func btn_Approve(_ sender: Any)
    {
        ApproveAPI()
    }
    
    @IBAction func btn_Disapprove(_ sender: Any) {
        if txt_Remark.text == ""
        {
            
            
            let alertController = UIAlertController(title: base.alertname, message: "Remark field should not be blank.", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                
            }
            // Add the actions
            alertController.addAction(okAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        else {
            
            // Create the alert controller
            let alertController = UIAlertController(title: base.alertname, message: "Are you sure?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.DisApproveAPI()
                
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func btn_Cancil(_ sender: Any) {
        self.cancelAPI()
        
    }
    
    
}



extension CODetailsVC
{
    func languagechange()
    {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {   self.title = "Details"
                name.text = "Name"
                empcode.text = "Emp Code"
                department.text = "Department"
                desigination.text = "Designation"
                location.text =  "Location"
                requestDetails.text = "Request Details"
                requestnumber.text = "Request No"
                submitdate.text = "Submit Date"
                leavetype.text = "Leave Type"
                contact.text = "Contact"
                fromdate.text = "From Date"
                todate.text = "To Date"
                numberofdays.text = "No. of Days"
                submitBy.text = "Submitted By"
                puspose.text = "Purpose"
                reporintmanager.text = "Reporting Manager"
                RMremarks.text = "Remarks"
                txt_Remark.placeholder = "Enter Remarks"
 
                
            }
            else
            {
                   self.title = "विवरण"
                   name.text = "नाम"
                   empcode.text = "कर्मचारी कोड"
                   department.text = "विभाग"
                   desigination.text = "पद"
                   location.text =  "स्थान"
                   requestDetails.text = "अनुरोध विवरण "
                   requestnumber.text = "अनुरोध संख्या"
                   submitdate.text = "जमा करने की तारीख"
                   leavetype.text = "छुट्टी का प्रकार"
                   contact.text = "संपर्क नंबर"
                   fromdate.text = "आरंभ करने की तिदिनांकथि"
                   todate.text = "अंतिम दिनांक"
                   numberofdays.text = "दिनों की संख्या"
                   submitBy.text = "द्वारा प्रस्तुत"
                   puspose.text = "उद्देश्य"
                   reporintmanager.text = "रिपोर्टिंग प्रबंधक"
                   RMremarks.text = "टिप्पणियां"
                   txt_Remark.placeholder = "टिप्पणी दर्ज करें"
                  
                
            }
        }
    }
}
