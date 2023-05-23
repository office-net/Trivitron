//
//  SLNewRequest.swift
//  NewOffNet
//
//  Created by Ankit Rana on 29/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class SLNewRequest: UIViewController, UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource , UIPickerViewDelegate{
  
    @IBOutlet weak var txtDestination: UILabel!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtName: UILabel!
    @IBOutlet weak var txtReasonForGoingOut: UITextView!
    @IBOutlet weak var txtFromTime: UITextField!
    @IBOutlet weak var txtToTime: UITextField!
 
    var SlfromTimelist:JSON = []
    var SlToTimelist:JSON = []
    var gradePicker = UIPickerView()
    var fromTimeId = ""
    var totimeid = ""
        override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Request"
        txtReasonForGoingOut.text = "Enter Here..."
        txtReasonForGoingOut.textColor = UIColor.lightGray
        txtReasonForGoingOut.delegate = self
        if let img2 = UIImage(named: "wallclock")
        {
            txtToTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
            txtFromTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
        }
        txtFromTime.delegate = self
        txtToTime.delegate = self
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.txtFromTime.inputView = gradePicker
        self.txtToTime.inputView = gradePicker
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let result = formatter.string(from: date)
            self.txtDate.text = result
            
        SL_getBasicDetails()
        SL_GetfromTimeApi()
            self.txtDate.delegate = self
            self.txtDate.setInputViewDatePicker(target: self, selector: #selector(tapStrtDate))
            
        
    }
    @objc func tapStrtDate() {
        if let datePicker = self.txtDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtDate.text = dateformatter.string(from: datePicker.date)
            self.SL_GetfromTimeApi()
            //2-4
        }
        self.txtDate.resignFirstResponder() // 2-5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtFromTime.isFirstResponder
        {
        return self.SlfromTimelist.arrayValue.count
        }
        else
        {
            return SlToTimelist.arrayValue.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txtFromTime.isFirstResponder
        {
        return SlfromTimelist[row]["ShiftFromTimeText"].stringValue
        }
        else
        {
            return SlToTimelist[row]["ShiftToTimeText"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if txtFromTime.isFirstResponder
        {
        txtFromTime.text = SlfromTimelist[row]["ShiftFromTimeText"].stringValue
        self.fromTimeId = SlfromTimelist[row]["ShiftFromTimeID"].stringValue
        print("--------------------------------------==================================--------\(txtFromTime.text!)")
        self.SltotimeApi()
        }
        else if txtFromTime.text == ""
        {
            showAlert(message: "Please Select From Time")
        }
        
          else
        {
            txtToTime.text = SlToTimelist[row]["ShiftToTimeText"].stringValue
             self.totimeid = SlToTimelist[row]["ShiftToTimeID"].stringValue
        }
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if txtFromTime.text == ""
        {
            self.showAlert(message: "Please Select From time")
        }
        else if txtToTime.text == ""
        {
            self.showAlert(message: "Please Select To time ")
        }
        else if txtReasonForGoingOut.text == "Enter Here..."
        {
        self.showAlert(message: "Please Enter Reason")
        }
        else
        {
        SlSubmitbtnApi()
    }
        
    }
    func SL_getBasicDetails()
    { CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]  }
        else {parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]}
        AF.request( base.url+"SL_GetBasicDetails", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.txtDestination.text = json["RMName"].stringValue
                        self.txtName.text = json["MobileNo"].stringValue
                    }
                    else
                    {CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.txtDestination.text = json["RMName"].stringValue
                        self.txtName.text = json["MobileNo"].stringValue }
                case .failure(let error):
                    print(" somthing went worng in api   \(error.localizedDescription)")
                }}}
    
    
    func SL_GetfromTimeApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Date":self.txtDate.text!] }
        else {  parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"] }
        AF.request( base.url+"SL_GetDataOnDateChange", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let value):
                    let json:JSON = JSON(value)
                    
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {  CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.SlfromTimelist = json["SLAttendanceTimeList"]
                        
                    }
                    else
                    {   CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    print("Api is not hit properly")
                }}}
    
    func SltotimeApi()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromTimeID":fromTimeId]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"SL_GetDataOnShiftFromTimeChange", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
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
                        self.SlToTimelist = json["SLAttendanceToTimeList"] }
                    else
                    { let msg = json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("something went wrong in api ")
                } }}
    
 func SlSubmitbtnApi()
 {
    CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
    var parameters:[String:Any]?
    if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"LeaveDate":self.txtDate.text!,"FromTime":self.txtFromTime.text! ,"ToTime":self.txtToTime.text!,"ContactNo":txtName.text!,"Purpose":self.txtReasonForGoingOut.text!]
    }
    else
    {parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"] }
    AF.request( base.url+"SL_SubmitRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result
            {
            case .success(let value):
                let json:JSON = JSON(value)
                print(json)
                print(response.request!)
                print(parameters!)
                let status =  json["Status"].intValue
                if status == 1
                {   let msg = json["Message"].stringValue
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
                        self.present(alertController, animated: true, completion: nil)
                }
                }
                else{
                    let mssg = json["Message"].stringValue
                    self.showAlert(message: mssg)
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            } }}

   
    
    
}

