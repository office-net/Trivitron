//
//  NewRequestVC.swift
//  NewOffNet
//
//  Created by Ankit Rana on 19/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController

class NewRequestVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var tReason: UILabel!
    
    @IBOutlet weak var titleLeaveApplyFor: UILabel!
    
    @IBOutlet weak var tAddress: UILabel!
    @IBOutlet weak var title_LeaveBalance: UILabel!
    
    @IBOutlet weak var ReportingMaNAGER: UILabel!
    
    
    @IBOutlet weak var titleContactNoDuringLeave: UILabel!
    
    @IBOutlet weak var txt_YearBlance: UITextField!
    
    @IBOutlet weak var txt_LeaveType: UITextField!
    @IBOutlet weak var txt_startDate: UITextField!
    @IBOutlet weak var txt_EndDate: UITextField!
    @IBOutlet weak var txt_Resion: UITextView!
    @IBOutlet weak var txt_address: UITextView!
    @IBOutlet weak var txt_mobonumber: UITextField!
    @IBOutlet weak var txt_ReportingManager: UITextField!
    @IBOutlet weak var btnSecondHalf: UIButton!
    @IBOutlet weak var lblAppyLeaveFor: UILabel!
    @IBOutlet weak var btnFirstHalf: UIButton!
    
    @IBOutlet weak var btn_submit: UIButton!
    var validation = Validation()
    var Leavetype:JSON = []
    var blancetype:JSON = []
    var gradePicker: UIPickerView!
    var strLeaveTypeID = ""
    var strFirstHalf = "0"
    var strSecondHalf = "0"
    var MaximumFrequency = ""
    var SystemLeaveName = ""
    var FutureGracePeriod = ""
    var CertificateReqDayLmt = ""
    var leavetypeeee = ""
     var CurrentYear = 20
    var txtYearss = [String]()
    
    
    var AlertLeaveType = ""
    var AlertfromDate = ""
    var AlertTodate = ""
    var AlertReasion = ""
    var AlertAddress = ""
    var AlertNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Languagchange()
       
        btn_submit.layer.cornerRadius = 10
 
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let tyear = components.year
        let ab:String = "\(tyear!)"
        self.CurrentYear = tyear!
        self.txt_YearBlance.text = ab
        self.txtYearss = ["\(tyear! - 1)","\(tyear!)","\(tyear! + 1)"]

        self.txt_LeaveType.layer.borderWidth = 0.5
        self.txt_LeaveType.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_LeaveType.layer.cornerRadius = 5
        
        self.txt_startDate.layer.borderWidth = 0.5
        self.txt_startDate.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_startDate.layer.cornerRadius = 5
        
        self.txt_EndDate.layer.borderWidth = 0.5
        self.txt_EndDate.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_EndDate.layer.cornerRadius = 5
        
        self.txt_Resion.layer.borderWidth = 0.5
        self.txt_Resion.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_Resion.layer.cornerRadius = 5
        
        self.txt_address.layer.borderWidth = 0.5
        self.txt_address.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_address.layer.cornerRadius = 5
        
        self.txt_mobonumber.layer.borderWidth = 0.5
        self.txt_mobonumber.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_mobonumber.layer.cornerRadius = 5
        
        self.txt_ReportingManager.layer.borderWidth = 0.5
        self.txt_ReportingManager.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.txt_ReportingManager.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        txt_LeaveType.delegate = self
        txt_LeaveType.inputView = gradePicker
        txt_YearBlance.inputView = gradePicker
        txt_YearBlance.delegate = self
        self.txt_startDate.delegate = self
        self.txt_EndDate.delegate = self
        self.txt_startDate.setInputViewDatePicker(target: self, selector: #selector(tapStrtDate))
        self.txt_EndDate.setInputViewDatePicker(target: self, selector: #selector(tapEndDate))
        self.txt_Resion.delegate = self
        self.txt_address.delegate = self
        
        if let myImage = UIImage(named: "calendar")
        {

            txt_startDate.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
            txt_EndDate.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
        }
         
        
        applyPlaceholderStyle(aTextview: txt_Resion!, placeholderText: "Reason of Leave")
        applyPlaceholderStyle(aTextview: txt_address!, placeholderText: "Address during Leave")
        
        // Call Api
        
        getblanveAPI()
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if txt_LeaveType.isFirstResponder
        {
        return Leavetype.arrayValue.count
    }
    else
        {
            return txtYearss.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if txt_LeaveType.isFirstResponder
        {
             if Leavetype.arrayValue.count > 0{
                return Leavetype[row]["LeaveTypeText"].stringValue
                
             }
        return ""
        }
        else
        {
            return txtYearss[row] as String
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txt_LeaveType.isFirstResponder
        {
            
            if Leavetype.arrayValue.count > 0{
                
                txt_LeaveType.text = Leavetype[row]["LeaveTypeText"].stringValue
                strLeaveTypeID = Leavetype[row]["LeaveTypeID"].stringValue
                leavetypeeee = self.Leavetype[row]["LeaveType"].stringValue
            }
           
        }
        else
        {
            txt_YearBlance.text = txtYearss[row] as String
        }
        
    }
    @objc func tapEndDate() {
        if let datePicker = self.txt_EndDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_EndDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_EndDate.resignFirstResponder() // 2-5
        self.Leave_CalculateDaysApi()
    }
    @objc func tapStrtDate() {
        if let datePicker = self.txt_startDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_startDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_startDate.resignFirstResponder()
        
        // 2-5
    }
    @IBAction func firstHalfAction(_ sender: Any) {
        strFirstHalf = "1"
        
        if (self.txt_startDate.text == "") {
            
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
       else if (self.txt_EndDate.text == "") {
            
           self.showAlert(message: self.AlertTodate)
            return
        }
        
       else if (self.txt_LeaveType.text == "") {
           self.showAlert(message: self.AlertLeaveType)
            return
        }
        
        else if btnFirstHalf.isSelected == true
        {     strFirstHalf = "0"
            btnFirstHalf.isSelected = false
            self.Leave_CalculateDaysApi()
        }
        
        else {

            btnFirstHalf.isSelected = true
            strFirstHalf = "1"
            self.Leave_CalculateDaysApi()
        }
        
    }
    
    
    @IBAction func btn_Balance(_ sender: Any) {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "LeaveBalanceVC") as! LeaveBalanceVC
        pvc.year = self.txt_YearBlance.text!
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 440)
        
        pvc.modalPresentationStyle = .overCurrentContext
        //  pvc.transitioningDelegate = self
        
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }
    
    
    @IBAction func secondHalfAction(_ sender: Any) {
        strSecondHalf = "1"
        if (self.txt_startDate.text == "") {
            
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
       else if (self.txt_EndDate.text == "") {
            
           self.showAlert(message: self.AlertTodate)
            return
        }
        
        else if (self.txt_LeaveType.text == "") {
            self.showAlert(message: self.AlertLeaveType)
            return
        }
        
        else if btnSecondHalf.isSelected == true
        {     strSecondHalf = "0"
            btnSecondHalf.isSelected = false
            self.Leave_CalculateDaysApi()
        }
        
        else {

            btnSecondHalf.isSelected = true
            strSecondHalf = "1"
            self.Leave_CalculateDaysApi()
        }
    }

    @IBAction func submitBtnAction(_ sender: Any) {
        self.validateFields()
        
    }
    func validateFields()  {
        
        if (self.txt_LeaveType.text == "" ) {
            self.showAlert(message: self.AlertLeaveType)
            return
        }
        if (self.txt_startDate.text == "") {
            self.showAlert(message: self.AlertfromDate)
            return
        }
        
        if (self.txt_EndDate.text == "") {
            
            self.showAlert(message: self.AlertTodate)
            return
        }
        
        if (self.txt_Resion.text == "") {
            
            self.showAlert(message: self.AlertReasion)
            return
        }
        
        if (self.txt_address.text == "") {
            
            self.showAlert(message: self.AlertAddress)
            return
        }
        
        let isValidateMobileNumber = self.validation.validaPhoneNumber(phoneNumber: self.txt_mobonumber.text!)
        if (isValidateMobileNumber == false) {
            self.showAlert(message: self.AlertNumber)
            return
        }
        else {
            self.subbmitAPI()
        }
    }
    
    // Service Call
    func getblanveAPI()
    {     CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int ,
           let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"PlantID":PlantID,"Year": self.CurrentYear]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year": "2021"]
        }
        
        AF.request(base.url+"Leave_GetBalance", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        switch response.result
                        {
                              
                        case .success(let value):
                            let json = JSON(value)
                            print(json)
                            print(response.request!)
                            print(parameters!)
                            let status =  json["Status"].intValue
                            if status == 1
                            {
                            CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                            self.Leavetype = json["objLeaveType"]
                            self.blancetype = json["objLeaveBalanceType"]
                                
                            DispatchQueue.main.async {
                                self.txt_ReportingManager.text = json["RMName"].stringValue
                                
                                
                            }
                            
                            }
                            else
                            
                            {
                                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                                let msg =  json["Message"].stringValue
                                self.showAlert(message: msg)
                            }
                    
                       // print(json)
                        case .failure(_):
                            print("Chutiya Kt Gya tumahara")
                        }
                    
                    
                    
                    }
    }
    
    
    
    
    // Service Call
    func Leave_GetDataOnLeaveTypeChangeApi()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":"2021"]
        }
        print(parameters)
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"Leave_GetDataOnLeaveTypeChange")! //change the url
        //create the session object
        print(url)
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
                    print(request)
                    print(parameters!)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        self.MaximumFrequency = (json["MaximumFrequency"] as? String ?? "")
                        self.SystemLeaveName = (json["SystemLeaveName"] as? String ?? "")
                        self.CertificateReqDayLmt = (json["CertificateReqDayLmt"] as? String ?? "")
                        self.FutureGracePeriod = (json["FutureGracePeriod"] as? String ?? "")
                        DispatchQueue.main.async {
                            if self.txt_startDate.text != "" && self.txt_EndDate.text != "" && self.txt_LeaveType.text != "" {
                                self.Leave_CalculateDaysApi()
                                
                            }                                               }
                    }else {
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
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
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    
    // Service Call
    func Leave_CalculateDaysApi()  {
        
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text ?? "","MaximumFrequency":MaximumFrequency,"SystemLeaveName":SystemLeaveName,"FutureGracePeriod":FutureGracePeriod,"CertificateReqDayLmt":CertificateReqDayLmt,"SecondHalfLeave":strSecondHalf,"FirstHalfLeave":strFirstHalf,"FromDate":self.txt_startDate.text ?? "","ToDate":self.txt_EndDate.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":"2021"]
        }
        print(parameters)
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"Leave_CalculateDays")! //change the url
        print(url)
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
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
                    print(request)
                    print(parameters!)
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        DispatchQueue.main.async {
                            let noOfDays = json["NoOfDays"] as? Float
                            self.lblAppyLeaveFor.text = "\(noOfDays ?? 0.0)"
                            self.btn_submit.isUserInteractionEnabled = true
                        }
                        
                    }else {
                        let Message = json["Message"] as? String
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                        // Create the actions
                        let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            //self.navigationController?.popViewController(animated: true)
                            self.btn_submit.isUserInteractionEnabled = false
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    // Service Call
    
    
    func subbmitAPI ()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"LeaveTypeID":strLeaveTypeID,"LeaveTypeText":self.txt_LeaveType.text!,"SecondHalfStatus":self.strSecondHalf,"FirstHalfStatus":strFirstHalf,"FromDate":self.txt_startDate.text!,"ToDate":self.txt_EndDate.text!,"NoOfDays":self.lblAppyLeaveFor.text!,"Reason":self.txt_Resion.text!,"Address":self.txt_address.text!,"ContactNo":self.txt_mobonumber.text!,"SystemLeaveType":self.txt_LeaveType.text!,"BalanceYearType":self.CurrentYear,"DeliveryDate":"","LeaveCompOffReq":"","CompOffID":"","FileInBase64":"","FileExt":"","Remarks":""]
        }
        else
        {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year": ""]
        }
        AF.request(base.url+"leaveSubmitRequest", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
                            {
                                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                                let Message = json["Message"].stringValue
                                let alertController = UIAlertController(title: base.Title, message: Message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.navigationController?.popViewController(animated: true)
                                }
                                       alertController.addAction(okAction)
                                // Present the controller
                                         DispatchQueue.main.async {
                                       self.present(alertController, animated: true, completion: nil)
                                }

                                
                            }
                            else{
                                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                                let msg = json["Message"].stringValue
                                let alertController = UIAlertController(title:base.Title, message: msg, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: base.ok, style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.navigationController?.popViewController(animated: true)
                                }
                                       alertController.addAction(okAction)
                                // Present the controller
                                         DispatchQueue.main.async {
                                       self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    
                    }
        
    }
    
    

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
        if textField == txt_LeaveType{
            
            
            
            if txt_LeaveType.text == "" {
                
                if Leavetype.arrayValue.count > 0 {
                   txt_LeaveType.text =  Leavetype[0]["LeaveTypeText"].stringValue
                    strLeaveTypeID = Leavetype[0]["LeaveTypeID"].stringValue
                    
                }
                
            }
            else {
                
            }
            Leave_GetDataOnLeaveTypeChangeApi()
         
        }
        
        if textField == txt_startDate {
            
            
            if txt_startDate.text != "" && txt_EndDate.text != "" && txt_LeaveType.text != "" {
                Leave_CalculateDaysApi()
                
            }
        }
        
        if textField == txt_startDate {
            
            
            if txt_startDate.text != "" && txt_EndDate.text != "" && txt_LeaveType.text != "" {
                
                Leave_CalculateDaysApi()
                
            }
        }
        

    }
    // textView
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGray
        aTextview.text = placeholderText
    }
    
    func applyNonPlaceholderStyle(aTextview: UITextView)
    {
        // make it look like normal text instead of a placeholder
        aTextview.textColor = UIColor.darkText
        aTextview.alpha = 1.0
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 // have text, so don't show the placeholder
        {
            // check if the only text is the placeholder and remove it if needed
            // unless they've hit the delete button with the placeholder displayed
            if textView == txt_Resion && textView.text == "Reason of Leave"
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            
            if textView == txt_address && textView.text == "Address during Leave"
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(aTextview: textView)
                textView.text = ""
            }
            return true
        }
        else  // no text, so show the placeholder
        {
            if textView == txt_address{
                applyPlaceholderStyle(aTextview: textView, placeholderText: "Address during Leave")
            }
            else {
                applyPlaceholderStyle(aTextview: textView, placeholderText: "Reason of Leave")
            }
            moveCursorToStart(aTextView: textView)
            return false
        }
    }
    
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
    {
        if aTextView == txt_Resion && aTextView.text == "Reason of Leave"
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
        }
        
        if aTextView == txt_address && aTextView.text == "Address during Leave"
        {
            // move cursor to start
            moveCursorToStart(aTextView: aTextView)
        }
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        
        DispatchQueue.main.async {
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
}


    




extension NewRequestVC
{
    func Languagchange()
    {
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "New Request"
                self.title_LeaveBalance.text = "Leave Balance Details"
                self.txt_LeaveType.placeholder = " Select Leave Type"
                self.txt_startDate.placeholder = "Start Date"
                self.txt_EndDate.placeholder = "End Date"
                self.btnFirstHalf.setTitle("Firts Half", for: .normal)
                self.btnSecondHalf.setTitle("Second Half", for: .normal)
                self.titleLeaveApplyFor.text = "Applying Leave For"
                
                self.btnSecondHalf.setTitle("Second Half", for: .normal)
                self.btnFirstHalf.setTitle("First Half", for: .normal)
                self.tReason.text = "Reason Of Leave"
                self.tAddress.text = "Address During Leave"
                self.titleContactNoDuringLeave.text = "Contact No. During Leave"
                self.ReportingMaNAGER.text = "Reporting Manager"
                self.btn_submit.setTitle("SUBMIT", for: .normal)
                
                self.AlertLeaveType = "Please Select Leave Type"
                self.AlertfromDate = "Please Select From Date"
                self.AlertTodate = "Please Select End Date"
                self.AlertReasion = "Please Enter Reason Of Leave"
                self.AlertAddress = "Please Enter Addres During Leave"
                self.AlertNumber = "Please Enter Correct Mobile Number"
                

            }
            else
            {
                
                self.title = "नया अवकाश फॉर्म"
                self.title_LeaveBalance.text = "अवकाश शेष विवरण"
                self.txt_LeaveType.placeholder = "छुट्टी का प्रकार चुनें"
                self.txt_startDate.placeholder = "प्रारंभ दिनांक"
                self.txt_EndDate.placeholder = "अंतिम दिनांक"
                self.btnFirstHalf.setTitle("पहला आधा दिन", for: .normal)
                self.btnSecondHalf.setTitle("दूसरा आधा दिन", for: .normal)
                self.titleLeaveApplyFor.text = " छुट्टी के लिए आवेदन दिन"
                self.btnSecondHalf.setTitle("द्वितीय सत्र", for: .normal)
                self.btnFirstHalf.setTitle("प्रथम सत्र", for: .normal)
                self.tReason.text = "छुट्टी का कारण"
                self.tAddress.text = "छुट्टी के दौरान पता"
                self.titleContactNoDuringLeave.text = "छुट्टी के दौरान संपर्क नंबर"
                self.ReportingMaNAGER.text = "रिपोर्टिंग प्रबंधक"
                self.btn_submit.setTitle("छुट्टी फॉर्म जमा करें", for: .normal)
                self.txt_mobonumber.text = "नंबर डालें"
                self.AlertLeaveType = "कृपया छुट्टी का प्रकार चुनें"
                self.AlertfromDate = "कृपया प्रारंभ दिनांक चुनें"
                self.AlertTodate = "कृपया अंतिम दिनांक चुनें"
                self.AlertReasion =  "कृपया छुट्टी का कारण दर्ज करें"
                self.AlertAddress = "कृपया छुट्टी के दौरान पता दर्ज करें"
                self.AlertNumber = "कृपया सही मोबाइल नंबर दर्ज करें"

            }
        }

    }
}
