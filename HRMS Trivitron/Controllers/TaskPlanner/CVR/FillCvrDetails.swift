//
//  FillCvrDetails.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit
import SwiftyJSON
import CoreLocation

class FillCvrDetails: UIViewController {

    var dict = [String:Any]()
    
    var gradePicker: UIPickerView!
    @IBOutlet weak var btn_Submit: Gradientbutton!
    var delegate:FillCvr?
    var BackData:JSON = []
    var Categoryofindustry:JSON = []
    var IDcatagory = ""
    var Productofinterest:JSON = []
    var IDproductInterest = ""
    var actionRequired:JSON = []
    var IDactionRequired = ""
    var clientInformation:JSON = []
    var IDclintinformation = ""
    var reasonOfVisit:JSON = []
    var IDreasonOfVisir = ""
    var typeOfVisit:JSON = []
    var IDtypeVisit = ""
    var CUST_TYPE = ""
    var currentAddress = ""
    var locationManager:CLLocationManager!
    @IBOutlet weak var Desigination: UILabel!
    @IBOutlet weak var EmpCode: UILabel!
    @IBOutlet weak var EMpname: UILabel!
    @IBOutlet weak var  Branch: UILabel!
    @IBOutlet weak var CustomerName: UILabel!
    @IBOutlet weak var lbl_ContactMailID: UILabel!
    
    @IBOutlet weak var txt_OutComeOfVisit: UITextField!
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var lbl_ContactNumber: UILabel!
    @IBOutlet weak var lbl_ContactPerson: UILabel!
    @IBOutlet weak var txt_State: UITextField!
    @IBOutlet weak var txt_CapitalCity: UITextField!
    
    @IBOutlet weak var txt_Remarks: UITextField!
    
    @IBOutlet weak var txt_ClientInformAtion: UITextField!
    @IBOutlet weak var txt_TypeOfVisit: UITextField!
    
    @IBOutlet weak var txt_DayOfVisit: UITextField!
    @IBOutlet weak var txt_TimeOfVisit: UITextField!
    
    @IBOutlet weak var txt_ProductIntrest: UITextField!
    
    @IBOutlet weak var txt_CatagoryIndustry: UITextField!
    
    @IBOutlet weak var txt_VisitResion: UITextField!
    @IBOutlet weak var txt_ActionRequired: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskID = BackData["TaskId"].stringValue
        
        self.ApiCallingForBindData(TaskId: taskID)
        UIsetup()
    }
    

    @IBAction func btn_Submit(_ sender: Any) {
        submitData()
   
    }
    

}




extension FillCvrDetails
{
    
    func submitData()
    {
        if txt_State.text == ""
        {
            self.showAlert(message: "Please Enter State Name")
        }
        else if txt_CapitalCity.text == ""
        {
            self.showAlert(message: "Please Enter City Name")
        }
        else if txt_Location.text == ""
        {
            self.showAlert(message: "Please Enter Location")
        }
        else if txt_TypeOfVisit.text == " -- Select Type Of Visit --"
        {
            self.showAlert(message: "Please  -- Select Type Of Visit --")
        }
        else if txt_DayOfVisit.text == " -- Select Day Of Visit --"
        {
            self.showAlert(message: "Please  -- Select Day Of Visit --")
        }
        else if txt_TimeOfVisit.text == " -- Select Time Of Visit --"
        {
            self.showAlert(message: "Please   -- Select Time Of Visit --")
        }
        else if txt_ProductIntrest.text == " -- Select Product of Interest --"
        {
            self.showAlert(message: " -- Select Product of Interest --")
        }
        else if txt_ClientInformAtion.text == " -- Select Client Information --"
        {
            self.showAlert(message: " -- Select Client Information --")
        }
        else if txt_CatagoryIndustry.text == " -- Select Category of Industry --"
        {
            self.showAlert(message: " -- Select Category of Industry --")
        }
        else if txt_VisitResion.text == " -- Select Reason of Visit --"
        {
            self.showAlert(message: " -- Select Reason of Visit --")
        }
        else if txt_OutComeOfVisit.text == ""
        {
            self.showAlert(message: "Please Enter Outcome Of Visit")
        }
        else if txt_ActionRequired.text == " -- Select action required --"
        {
            self.showAlert(message: " -- Select action required --")
        }
        else if txt_Remarks.text == ""
        {
            self.showAlert(message: "Please Enter Remarks")
        }
        else
        {
            self.dict = ["ACTION_REQ":IDactionRequired,"BRANCH":"HO","CATE_OF_INTEREST":IDcatagory,"CITY_NAME":txt_CapitalCity.text ?? "","CLIENT_INFORMATION":IDclintinformation,"CONTACT_NO":lbl_ContactNumber.text ?? "","CUSTOMER_NAME":CustomerName.text ?? "","CUSTOMER_TYPE":CUST_TYPE,"DATE_OF_VISIT":txt_DayOfVisit.text ?? "","DESIGNATION":Desigination.text ?? "","EMAIL_ID":lbl_ContactMailID.text ?? "","EMP_CODE":EmpCode.text ?? "","EMP_NAME":EMpname.text ?? "","LOCATION":currentAddress ,"OtherProduct":"","OUTCOME_OF_VISIT":txt_OutComeOfVisit.text ?? "","PERSON_NAME":lbl_ContactPerson.text ?? "","PROD_OF_INTEREST":IDproductInterest,"REASON_OF_VISIT":IDreasonOfVisir,"REMARKS":txt_Remarks.text ?? "","STATE_NAME":txt_State.text ?? "","TIME_OF_VISIT":txt_TimeOfVisit.text ?? "","TYPE_OF_VISIT":IDtypeVisit] as [String : Any]
            delegate?.Action(CvrData: dict)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}







extension FillCvrDetails
{
    func ApiCallingForBindData(TaskId:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskId] as [String : Any]
                          
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CVRDataBindList", parameters: parameters) { (response,data) in
            let json:JSON = response
            //print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.actionRequired = json["actionRequired"]
                self.Categoryofindustry = json["Categoryofindustry"]
                self.clientInformation = json["clientInformation"]
                self.Productofinterest = json["Productofinterest"]
                self.reasonOfVisit = json["reasonOfVisit"]
                self.typeOfVisit = json["typeOfVisit"]
                
                self.txt_CapitalCity.text = json["CityName"].stringValue
                self.txt_State.text = json["StateName"].stringValue
                if self.txt_CapitalCity.text == ""
                {
                    self.txt_CapitalCity.isUserInteractionEnabled = true
                }
                else
                {
                    self.txt_CapitalCity.isUserInteractionEnabled = false
                }
                if self.txt_State.text == ""
                {
                    self.txt_State.isUserInteractionEnabled = true
                }
                else
                {
                    self.txt_State.isUserInteractionEnabled = false
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

extension FillCvrDetails: UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate
{

    
    func UIsetup()
    {
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.Branch.text = "HO"
        self.CUST_TYPE = BackData["CUST_TYPE"].stringValue
        
        self.currentAddress = BackData["CUSTOMER_LOCATION"].stringValue
        if currentAddress == ""
        {
            txt_Location.isUserInteractionEnabled  = true
        }
        else
        {
            txt_Location.text = currentAddress
            txt_Location.isUserInteractionEnabled  = false
        }
        self.CustomerName.text = BackData["CUSTOMER_NAME"].stringValue
        self.lbl_ContactPerson.text = BackData["ContactPerson"].stringValue
        self.lbl_ContactNumber.text = BackData["CONTACT_NO"].stringValue
        self.lbl_ContactMailID.text = BackData["EMAIL_ID"].stringValue
        self.txt_TypeOfVisit.delegate = self
        self.txt_TypeOfVisit.inputView = gradePicker
        self.txt_ProductIntrest.delegate = self
        self.txt_ProductIntrest.inputView = gradePicker
        self.txt_CatagoryIndustry.delegate = self
        self.txt_CatagoryIndustry.inputView = gradePicker
        self.txt_VisitResion.delegate = self
        self.txt_VisitResion.inputView = gradePicker
        self.txt_ActionRequired.delegate = self
        self.txt_ActionRequired.inputView = gradePicker
        self.txt_ClientInformAtion.delegate = self
        self.txt_ClientInformAtion.inputView = gradePicker
        
        self.txt_DayOfVisit.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
        self.txt_TimeOfVisit.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneStartTime))
        
        base.changeImageCalender(textField: self.txt_DayOfVisit)
        base.changeImageClock(textField: self.txt_TimeOfVisit)
        let UserName  = UserDefaults.standard.object(forKey: "UserName") as? String
        self.EMpname.text = UserName
        let EmpCode  = UserDefaults.standard.object(forKey: "EmpCode") as? String
        self.EmpCode.text = EmpCode
        let Desigination  = UserDefaults.standard.object(forKey: "Designation") as? String
        self.Desigination.text = Desigination
        
        
        
       
        
        
        
        
        
    }
    @objc func tapDoneEndDate() {
        if let datePicker = self.txt_DayOfVisit.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt_DayOfVisit.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_DayOfVisit.resignFirstResponder() // 2-5
    }
    @objc func tapDoneStartTime() {
        if let datePicker = self.txt_TimeOfVisit.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm:ss"
            
            self.txt_TimeOfVisit.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_TimeOfVisit.resignFirstResponder() // 2-5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txt_TypeOfVisit.isFirstResponder
        {
            return self.typeOfVisit.count
        }
        else if txt_ProductIntrest.isFirstResponder
        {
            return self.Productofinterest.count
        }
        else if txt_CatagoryIndustry.isFirstResponder
        {
            return self.Categoryofindustry.count
        }
        else if txt_VisitResion.isFirstResponder
        {
            return self.reasonOfVisit.count
        }
        else if txt_ClientInformAtion.isFirstResponder
        {
            return self.clientInformation.count
        }
        else
        {
            return self.actionRequired.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if txt_TypeOfVisit.isFirstResponder
        {
            return self.typeOfVisit[row]["Name"].stringValue
        }
        else if txt_ProductIntrest.isFirstResponder
        {
            return self.Productofinterest[row]["ProductName"].stringValue
        }
        else if txt_CatagoryIndustry.isFirstResponder
        {
            return self.Categoryofindustry[row]["CategoryName"].stringValue
        }
        else if txt_VisitResion.isFirstResponder
        {
            return self.reasonOfVisit[row]["Name"].stringValue
        }
        else if txt_ClientInformAtion.isFirstResponder
        {
            return self.clientInformation[row]["Name"].stringValue
        }
        else
        {
            return self.actionRequired[row]["Name"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txt_TypeOfVisit.isFirstResponder
        {
            txt_TypeOfVisit.text =  self.typeOfVisit[row]["Name"].stringValue
            IDtypeVisit = self.typeOfVisit[row]["ID"].stringValue
        }
        else if txt_ProductIntrest.isFirstResponder
        {
            txt_ProductIntrest.text =  self.Productofinterest[row]["ProductName"].stringValue
            IDproductInterest = self.typeOfVisit[row]["ProductId"].stringValue
        }
        else if txt_CatagoryIndustry.isFirstResponder
        {
            txt_CatagoryIndustry.text =  self.Categoryofindustry[row]["CategoryName"].stringValue
            IDcatagory = self.typeOfVisit[row]["CategoryId"].stringValue
        }
        else if txt_VisitResion.isFirstResponder
        {
            txt_VisitResion.text =  self.reasonOfVisit[row]["Name"].stringValue
            IDreasonOfVisir = self.typeOfVisit[row]["ID"].stringValue
        }
        else if txt_ClientInformAtion.isFirstResponder
        {
            txt_ClientInformAtion.text =  self.clientInformation[row]["Name"].stringValue
            IDclintinformation = self.typeOfVisit[row]["ID"].stringValue
        }
        else
        {
            txt_ActionRequired.text =  self.actionRequired[row]["Name"].stringValue
            IDactionRequired = self.typeOfVisit[row]["ID"].stringValue
        }
    }
    
    
}

