//
//  ODNewRequestVC.swift
//  Myomax officenet
//
//  Created by Mohit Sharma on 05/05/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit

class ODNewRequestVC: UIViewController  , UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var txtRM: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtReason: UITextField!
    @IBOutlet weak var txtToTime: UITextField!
    @IBOutlet weak var txtFromTime: UITextField!
    @IBOutlet weak var txtFromDate: UITextField!
    @IBOutlet weak var txtToDate: UITextField!
    @IBOutlet weak var txtSelectType: UITextField!
    
    @IBOutlet weak var txtPlace: UITextField!
    
    
    
    var gradePicker: UIPickerView!
    var  arrObjARRegularizationType = [] as NSMutableArray
    var strTypeId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        txtToDate.isHidden = true
        self.title = "New Request"
        if let myImage = UIImage(named: "calendar")
        {

            txtFromDate.withImage(direction: .Left, image: myImage, colorBorder: UIColor.clear)
            txtToDate.withImage(direction: .Left, image: myImage,  colorBorder: UIColor.clear)
        }
         if let img2 = UIImage(named: "wallclock")
         {
            txtToTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
            txtFromTime.withImage(direction: .Left, image: img2,  colorBorder: UIColor.clear )
         }
        
        
        
        
        
        
        
        
        
        
        gradePicker = UIPickerView()
        gradePicker.dataSource = self
        gradePicker.delegate = self
        txtSelectType.delegate = self
        txtSelectType.inputView = gradePicker
        
        self.txtFromDate.delegate = self
        self.txtToDate.delegate = self
        
        self.txtFromTime.delegate = self
        self.txtToTime.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        self.txtFromDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneFromDate))
        self.txtToDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneToDate))
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.txtFromTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneFromTime))
        self.txtToTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneToTime))
        
        self.OD_GetBasicDetailsAPI()
        
    }
    @objc func tapDoneFromDate() {
        if let datePicker = self.txtFromDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtFromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtFromDate.resignFirstResponder() // 2-5
    }
       
    @objc func tapDoneToDate() {
        if let datePicker = self.txtToDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txtToDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtToDate.resignFirstResponder() // 2-5
    }
    
    @objc func tapDoneFromTime() {
        if let datePicker = self.txtFromTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm"
            
            self.txtFromTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtFromTime.resignFirstResponder() // 2-5
    }
          
    @objc func tapDoneToTime() {
        if let datePicker = self.txtToTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "HH:mm"
            self.txtToTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txtToTime.resignFirstResponder() // 2-5
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return arrObjARRegularizationType.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if arrObjARRegularizationType.count > 0{
            let dic  = arrObjARRegularizationType[row] as! NSDictionary
            return dic.value(forKey: "Text") as? String
        }
        return ""
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        
        let dic  = arrObjARRegularizationType[row] as! NSDictionary
        txtSelectType.text = dic.value(forKey: "Text") as? String
        if txtSelectType.text == "Missed In-Out Punch Regularisation"
        {
            txtToDate.isHidden = true
     
        }
        
        else
        {
            txtToDate.isHidden = false
            txtToTime.isHidden = false
            txtFromTime.isHidden =  false
            txtFromDate.isHidden =  false
        }
        strTypeId = (dic.value(forKey: "ID") as? String)!
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
        
        if (self.txtSelectType.text == "" ) {
            self.showAlert(message: "Please select type")
            return
        }
        
        else   if (self.txtFromDate.text == "" ) {
            self.showAlert(message: "Please select from date")
            return
        }
        else   if txtToDate.isHidden == false && self.txtToDate.text == ""  {
            self.showAlert(message: "Please select to date")
            return
        }
        else   if txtFromTime.isHidden == false && self.txtFromTime.text == ""  {
            self.showAlert(message: "Please select from time")
            return
        }
        
        else   if txtToTime.isHidden == false && self.txtToTime.text == ""  {
            self.showAlert(message: "Please select to time")
            return
        }
        else   if (self.txtPlace.text == "" ) {
            self.showAlert(message: "Please enter place")
            return
        }
        else   if (self.txtReason.text == "" ) {
            self.showAlert(message: "Please enter Reason")
            return
        }
        
        else   if (self.txtMobileNumber.text == "" ) {
            self.showAlert(message: "Please enter contact number")
            return
        }
        
        else   if (self.txtRM.text == "" ) {
            self.showAlert(message: "Please enter RM Name")
            return
        }
        else {
            OD_SubmitRequestAPI()
        }
        
    }
    
    
    
    // Service Call
    func OD_GetBasicDetailsAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int , let PlantID = UserDefaults.standard.object(forKey: "PlantID") as? String{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"OD_GetBasicDetails")! //change the url
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
                    
                    let status = json["Status"] as? Int
                    
                    if status == 1 {
                        
                        self.arrObjARRegularizationType = json["objARRegularizationType"] as! NSMutableArray
                        
                        DispatchQueue.main.async {
                            
                            if self.arrObjARRegularizationType.count > 0{
                                let dic  = self.arrObjARRegularizationType[0] as! NSDictionary
                                self.txtSelectType.text =  dic.value(forKey: "Text") as? String
                                self.strTypeId = (dic.value(forKey: "ID") as? String)!
                                
                            }
                            self.txtRM.text = json["RMName"] as? String
                            self.txtMobileNumber.text = json["MobileNo"] as? String
                            
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
    
    
       // Service Call
    func OD_SubmitRequestAPI()  {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        let arrFromTime = self.txtFromTime.text?.components(separatedBy: ":")
        var strFromTimeHours = ""
        var strFromTimeMins = ""
        if txtFromTime.isHidden == false
        {
         strFromTimeHours = arrFromTime![0]
         strFromTimeMins = arrFromTime![1]
        }
        
        let arrToTime = self.txtToTime.text?.components(separatedBy: ":")
        var strToTimeHours = ""
        var strToTimeMins = ""
        if txtToTime.isHidden == false
        {
         strToTimeHours = arrToTime![0]
         strToTimeMins = arrToTime![1]
        }
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":txtFromDate.text ?? "","FromTimeHour":strFromTimeHours,"FromTimeMin":strFromTimeMins,"ToDate":self.txtToDate.text ?? "","ToTimeHour":strToTimeHours,"ToTimeMin":strToTimeMins,"Reason":self.txtReason.text ?? "","RegularizationTypeID":strTypeId,"ContactNo":self.txtMobileNumber.text ?? "","Place":self.txtPlace.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"OD_SubmitRequest")! //change the url
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
                    print(request)
                    print(parameters)
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
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtSelectType{
            // gradePicker.selectRow(0, inComponent: 0, animated: false)
        }
        
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtSelectType{
            
            
            if txtSelectType.text == "" {
                
                if arrObjARRegularizationType.count > 0{
                    let dic  = arrObjARRegularizationType[0] as! NSDictionary
                    txtSelectType.text =  dic.value(forKey: "Text") as? String
                    strTypeId = (dic.value(forKey: "ID") as? String)!
                    
                }
            }else {
                
            }
            
            if txtSelectType.text == "Out Door Duty"{
                //  viewToDate.isHidden = false
            }
            else {
                //  viewToDate.isHidden = true
                
            }
            
            
            
        }
        
        
        
    }
    
}


