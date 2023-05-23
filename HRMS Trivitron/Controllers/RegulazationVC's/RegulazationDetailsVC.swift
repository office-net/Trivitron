//
//  RegulazationDetailsVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 23/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegulazationDetailsVC: UIViewController {
  
    @IBOutlet weak var mainViewHight: NSLayoutConstraint!
    @IBOutlet weak var txt_remarks: UITextField!
    @IBOutlet weak var Requestdetailview: UIView!
    @IBOutlet weak var txt_MOboNo: UILabel!
    @IBOutlet weak var txt_ToDate: UILabel!
    @IBOutlet weak var txt_Fromtime: UILabel!
    @IBOutlet weak var txt_SubbmitedBY: UILabel!
    @IBOutlet weak var txt_ToTime: UILabel!
    @IBOutlet weak var txt_Reason: UILabel!
    @IBOutlet weak var txt_name: UILabel!
    @IBOutlet weak var txt_Type: UILabel!
    @IBOutlet weak var txt_empcode: UILabel!
    @IBOutlet weak var txt_Department: UILabel!
    @IBOutlet weak var txt_designation: UILabel!
    @IBOutlet weak var txt_location: UILabel!
    @IBOutlet weak var txt_requestNO: UILabel!
    @IBOutlet weak var txt_submitDate: UILabel!
    @IBOutlet weak var txt_FromDate: UILabel!
    @IBOutlet weak var txt_Remark: UITextField!
    @IBOutlet weak var btn_Approve: UIButton!
    @IBOutlet weak var lbl_RmStatus: UILabel!
    @IBOutlet weak var lbl_RmRemark: UILabel!
    @IBOutlet weak var lbl_HRstatus: UILabel!
    @IBOutlet weak var lbl_HRremark: UILabel!
    
    @IBOutlet weak var txt_RemarkHight: NSLayoutConstraint!
    
    @IBOutlet weak var stkViewHight: NSLayoutConstraint!

    @IBOutlet weak var btn_disApprove: UIButton!
    var RM_HOD_Flag = ""
    
    var dicObjleaveGetDetailsRes:JSON = []
    
    var IsFirstApprovalDetailsVisable = 0
    var IsApprovalbuttonVisable = 0
    var IsCancelDetailsVisable = 0
    var isFromCancelVC = false
    var isFromPendingVC = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        self.Requestdetailview.layer.borderWidth = 1
        self.Requestdetailview.layer.borderColor = base.firstcolor.cgColor
        
        btn_Approve.isHidden = true
        btn_disApprove.isHidden = true
        txt_Remark.isHidden = true
        if isFromPendingVC == true
        {
            self.btn_disApprove.setTitle("DISAPPROVE", for: .normal)
        }
        else
        {
            self.btn_disApprove.setTitle("CANCEL", for: .normal)
        }
        
        // Do any additional setup after loading the view.
        // OD_ViewRequestDetails()
        deatilsApi()
    }
    func deatilsApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let Type = dicObjleaveGetDetailsRes["Type"].stringValue
        
        let ReqID = dicObjleaveGetDetailsRes["ReqID"].stringValue
        
        let parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":ReqID ,"Type":Type]
        AF.request( base.url+"OD_ViewRequestDetails", method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                switch response.result
                {
                    
                case .success(let value):
                    
                    let json =  JSON(value)
                    print(json)
                    
                    let status = json["Status"].intValue
                    if status == 1 {
                        
                       
                        
                        self.RM_HOD_Flag = json["RM_HOD_Flag"].stringValue
                        self.txt_name.text = json["EmpName"].stringValue
                        
                        self.txt_empcode.text = json["EmpCode"].stringValue
                        
                        self.txt_Department.text = json["EmpDepartment"].stringValue
                        
                        self.txt_designation.text = json["EmpDesignation"].stringValue
                        
                        self.txt_location.text = json["EmpLocation"].stringValue
                        
                        self.txt_submitDate.text = json["ReqDate"].stringValue
                        
                        self.txt_Type.text = json["RegularisationType"].stringValue
                        
                        self.txt_FromDate.text = json["FromDate"].stringValue
                        
                        self.txt_ToDate.text = json["ToDate"].stringValue
                        self.txt_ToTime.text = json["ToTime"].stringValue
                        self.txt_Fromtime.text = json["FromTime"].stringValue
                        self.lbl_RmStatus.text = json["RMStatus"].stringValue
                        self.lbl_HRstatus.text = json["HODName"].stringValue
                        self.lbl_HRremark.text = json["Approver2_Remarks"].stringValue
                        if self.lbl_RmStatus.text == ""
                        {
                            self.lbl_RmStatus.text = ""
                        }
                        let color1 = json["RMStatus"].stringValue
                        if color1.contains("Disapproved")
                        {
                            self.lbl_RmStatus.textColor = UIColor.red
                        }
                        self.lbl_RmRemark.text = json["Approver1_Remarks"].stringValue
                   
                        let Contact = json["ContactNo"].stringValue
                        self.txt_MOboNo.text = Contact
                        let Reason = json["Reason"].stringValue
                        self.txt_Reason.text = Reason
                        
                        self.IsApprovalbuttonVisable = json["IsApprovalbuttonVisable"].intValue
                        let cancebtn = json["IsCancelButtonVisable"].intValue
                        
                        if self.IsApprovalbuttonVisable == 1{
                            DispatchQueue.main.async {
                                self.btn_Approve.isHidden = false
                                self.btn_disApprove.isHidden = false
                                self.txt_remarks.isHidden = false
                                self.txt_RemarkHight.constant = 40
                            }
                            
                        }
                        else if cancebtn == 1
                        {    self.txt_remarks.isHidden = false
                            self.txt_RemarkHight.constant = 40
                            self.btn_disApprove.isHidden = false
                        }
                        else
                        {
                            self.txt_RemarkHight.constant = 0
                            self.stkViewHight.constant = 0
                        }
                        DispatchQueue.main.async {
                            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        
    }
    
    
    @IBAction func btn_Approve(_ sender: Any) {
        if txt_remarks.text == ""
        {
            self.showAlert(message: "Please Fill Remarks")
        }
        else
        {
            OD_ApproveRequestAPI()
        }
    }
    
    
    @IBAction func btn_Disapprove(_ sender: Any) {
        if txt_remarks.text == "" {
            
            
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
                if self.isFromPendingVC == true
                {
                    self.OD_DisapproveRequestAPI()
                }
                else
                {
                    self.CancelLeaveAPI()
                }
                
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
    
    
    
    @IBAction func btn_Cancel(_ sender: Any) {
        CancelLeaveAPI()
        
    }
    
    
    func CancelLeaveAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let Req_No = dicObjleaveGetDetailsRes["ReqNo"].stringValue
        let ReqID = dicObjleaveGetDetailsRes["ReqID"].stringValue
        let Type = dicObjleaveGetDetailsRes["Type"].stringValue
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No,"ReqID":ReqID,"UserID":UserID,"Remarks":"Cancel","Type":Type]
        }
        else {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqNo":Req_No]
        }
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"OD_CancelledRequest")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let status = json["Status"] as? Int
                    if status == 1 {
                        let Message = json["Message"] as? String
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
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    func OD_ApproveRequestAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let ReqID = dicObjleaveGetDetailsRes["ReqID"].stringValue
        let Type = dicObjleaveGetDetailsRes["Type"].stringValue
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":ReqID,"UserID":UserID,"Remarks":txt_remarks.text ?? "","Type":Type]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":ReqID]
        }
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"OD_ApproveRequest")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let status = json["Status"] as? Int
                    if status == 1 {
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    func OD_DisapproveRequestAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let ReqID = dicObjleaveGetDetailsRes["ReqID"].stringValue
        let Type = dicObjleaveGetDetailsRes["Type"].stringValue
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":ReqID,"UserID":UserID,"Remarks":txt_remarks.text ?? "","Type":Type]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","ReqID":ReqID]
        }
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"OD_DisapproveRequest")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            
            do {
                
                DispatchQueue.main.async {
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let status = json["Status"] as? Int
                    if status == 1 {
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    
}
