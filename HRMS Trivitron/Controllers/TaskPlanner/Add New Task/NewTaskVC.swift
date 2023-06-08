//
//  NewTaskVC.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 26/09/22.
//

import UIKit
import SwiftyJSON
protocol AdditionalPeron:AnyObject
{
    func BtnPressed(tag:Int)
    
}
class NewTaskVC: UIViewController,AdditionalPeron {
    var gradePicker: UIPickerView!
    var meetingStatusArray = ["FIXED","TO BE CONFIRMED"]
    @IBOutlet weak var txt_StateName: UITextField!
    
    var TaskType = ""
    
    var CUST_TYPE = ""
    var CUSTOMER_NAME = ""
    var AdditionalPersonCount = ["1"]
    var strMeetingType = ""
    var GetData:JSON = []
    var CustomerData:JSON = []

    
    
    @IBOutlet weak var CompanyName: UITextField!
    @IBOutlet weak var txtContactPersonName:UITextField!
    @IBOutlet weak var txtContactPersonNumber:UITextField!
    @IBOutlet weak var txtCustomerLocation: UITextField!
    @IBOutlet weak var txtContactPersonEmail:UITextField!
    
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var HieghtTbl:NSLayoutConstraint!
    @IBOutlet weak var startDate:UITextField!
    @IBOutlet weak var startTime:UITextField!
    @IBOutlet weak var EndDate:UITextField!
    @IBOutlet weak var EndTime:UITextField!
    
    @IBOutlet weak var txt_MeetinfStatus: UITextField!
    
    
    @IBOutlet weak var txt_TaskActivity: UITextField!
    @IBOutlet weak var txt_CityName: UITextField!
    
    @IBOutlet weak var btn_PhysicalMeeting: UIButton!
    @IBOutlet weak var txt_SetReminder: UITextField!
    
    @IBOutlet weak var txt_Remarks: UITextField!
    @IBOutlet weak var btn_VartualMeeting: UIButton!
    
    @IBOutlet weak var vv: UIView!
    
    @IBOutlet weak var hh: NSLayoutConstraint!
    
    @IBOutlet weak var btn_MeetingNow: UIButton!
    
    @IBOutlet weak var btn_MeetingLater: UIButton!
    
    var StrMeetingNow = ""
    var StrMeetingLater = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add New Task"
        setupui()
        print(CustomerData)
        // Do any additional setup after loading the view.
    }
    func BtnPressed(tag: Int) {
        self.AdditionalPersonCount.append("1")
        
        tbl.reloadData()
    }
    
    @IBAction func btn_Physical(_ sender: Any) {
        self.strMeetingType = "Physical Meeting"
        btn_VartualMeeting.isSelected = false
        btn_PhysicalMeeting.isSelected = true
    }
    @IBAction func btn_Virtual(_ sender: Any) {
        self.strMeetingType = "Virtual Meeting"
        btn_VartualMeeting.isSelected = true
        btn_PhysicalMeeting.isSelected = false
    }
    
    
    
    
    @IBAction func btn_meetongNow(_ sender: Any) {
        self.StrMeetingNow = "Meeting Now"
        btn_MeetingLater.isSelected = false
        btn_MeetingNow.isSelected = true
    }
    
    
    
    @IBAction func mrrtingLater(_ sender: Any) {
        self.strMeetingType = "Meeting Later"
        btn_MeetingLater.isSelected = true
        btn_MeetingNow.isSelected = false
    }
    
    
    @IBAction func btn_Submit(_ sender: Any) {
        
        validation()
        //popToContact()
        
    }
    func popToContact() {
        if let contactVC = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(contactVC, animated: true)
        }
    }
    
    
}


extension NewTaskVC
{
    func ApiCalling()
    
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
        var arrayDish = [[String:Any]]()
        
        for i in 0...AdditionalPersonCount.count - 1
        {
            let index = IndexPath(row: i, section: 0)
            let cell: AddNewTaskCell = self.tbl.cellForRow(at: index) as! AddNewTaskCell
            if cell.name.text == "" && cell.number.text == "" && cell.desiginstiomn.text == "" && cell.email.text == "" && cell.AlternativeMobileNumber.text == ""
            {
                print(arrayDish)
            }
            else
            {
                let dict = ["PersonName":cell.name.text!,"ContactNo":cell.number.text!,"DESIGNATION":cell.desiginstiomn.text!,"Email_Id":cell.email.text!,"ID":UserID!,"TYPE":"D","AlternateMobNo":cell.AlternativeMobileNumber.text!] as [String : Any]
                
                arrayDish.append(dict)
            }
            
            
            
        }
        
        //print(arrayDish)
      
        let params:[String:Any] = ["TokenNo":token!,"UserId":UserID!,"CUST_TYPE":CUST_TYPE,"COMPANY_ID":CustomerData["LEAD_ID"].stringValue,"CUSTOMER_NAME":CUSTOMER_NAME,"ContactPerson":txtContactPersonName.text ?? "","CONTACT_NO":txtContactPersonNumber.text ?? "","EMAIL_ID":txtContactPersonEmail.text ?? "","CUSTOMER_LOCATION":txtCustomerLocation.text ?? "","SETASREMINDER_TM":txt_SetReminder.text ?? "","TASK_ACTIVITY":txt_TaskActivity.text ?? "","STARTS_DATE":startDate.text ?? "","START_TIME":startTime.text ?? "","END_DATE":EndDate.text ?? "","END_TIME":EndTime.text ?? "","MEETING_STATUS":txt_MeetinfStatus.text ?? "","MEETING_TYPE":strMeetingType,"REMARKS":txt_Remarks.text ?? "","CompanyName":"","state":txt_StateName.text ?? "","city":txt_CityName.text ?? "","ADDITIONAL_PERSON":arrayDish]
        print(params)
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"AddNewTask", parameters: params) { (response,data) in
            self.GetData = response
            let status = self.GetData["Status"].intValue
            if status == 1
            {
                print(self.GetData)
                let msg = self.GetData["Message"].stringValue
                // Create the alert controller
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.popToContact()
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
                let msg = self.GetData["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
    
    
}


extension NewTaskVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HieghtTbl.constant = CGFloat(AdditionalPersonCount.count*340)
        return AdditionalPersonCount.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewTaskCell", for: indexPath)as! AddNewTaskCell
        cell.btn.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  340
    }
    
    
    
    @objc func tapDonestartDate() {
        if let datePicker = self.startDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.startDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.startDate.resignFirstResponder() // 2-5
    }
    @objc func tapDoneEndDate() {
        if let datePicker = self.EndDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.EndDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.EndDate.resignFirstResponder() // 2-5
    }
    @objc func tapDoneStartTime() {
        if let datePicker = self.startTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm:ss"
            
            self.startTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.startTime.resignFirstResponder() // 2-5
    }
    @objc func tapDoneEndTime() {
        if let datePicker = self.EndTime.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm:ss"
            
            self.EndTime.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.EndTime.resignFirstResponder() // 2-5
    }
    @objc func tapDoneReminderTime() {
        if let datePicker = self.txt_SetReminder.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm:ss"
            
            self.txt_SetReminder.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_SetReminder.resignFirstResponder() // 2-5
    }
    func setupui()
    {
        
        
        switch TaskType
        {
        case "Lead":
          
            
            self.vv.isHidden = true
            self.hh.constant = 0
            self.CUSTOMER_NAME = CustomerData["LEAD_NAME"].stringValue
            self.txtContactPersonName.text = CustomerData["UserViewLeadCustomerlst"][0]["PCONTACT_PERSON_NAME"].stringValue
            self.txtContactPersonEmail.text = CustomerData["UserViewLeadCustomerlst"][0]["PEMAIL_ID"].stringValue
            self.txtContactPersonNumber.text = CustomerData["UserViewLeadCustomerlst"][0]["PCONTACT_NO"].stringValue
            self.txtContactPersonName.isUserInteractionEnabled = false
            self.txtContactPersonEmail.isUserInteractionEnabled = false
            self.txtContactPersonNumber.isUserInteractionEnabled = false
            CUST_TYPE = "L"
        case "Existing Customer":
          
            
            self.vv.isHidden = true
            self.hh.constant = 0
            self.txtContactPersonName.text = CustomerData["Contactpersonname"].stringValue
            self.txtContactPersonEmail.text = CustomerData["ContactpersonEmail"].stringValue
            self.txtContactPersonNumber.text = CustomerData["Contactpersonno"].stringValue
            self.CUSTOMER_NAME = CustomerData["CustomerName"].stringValue
            self.txtContactPersonName.isUserInteractionEnabled = false
            self.txtContactPersonEmail.isUserInteractionEnabled = false
            self.txtContactPersonNumber.isUserInteractionEnabled = false
            CUST_TYPE = "E"
            
            
        default:
            print("")
        }
      
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UINib(nibName: "AddNewTaskCell", bundle: nil), forCellReuseIdentifier: "AddNewTaskCell")
        base.changeImageCalender(textField: self.startDate)
        base.changeImageCalender(textField: self.EndDate)
        base.changeImageClock(textField: self.EndTime)
        base.changeImageClock(textField: self.startTime)
        
        
        self.startDate.setInputViewDatePicker(target: self, selector: #selector(tapDonestartDate))
        self.EndDate.setInputViewDatePicker(target: self, selector: #selector(tapDoneEndDate))
        self.startTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneStartTime))
        self.EndTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneEndTime))
        self.txt_SetReminder.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneReminderTime))
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.txt_MeetinfStatus.delegate = self
        txt_MeetinfStatus.inputView = gradePicker
    }
}



extension NewTaskVC: UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.meetingStatusArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.txt_MeetinfStatus.text = meetingStatusArray[row]
        return meetingStatusArray[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.txt_MeetinfStatus.text = meetingStatusArray[row]
    }
    
    
}

extension NewTaskVC
{
    func validation()
    {
        if  txtContactPersonName.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Name")
        }
        else if txtContactPersonNumber.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Number")
        }
        else if txtContactPersonEmail.text == ""
        {
            self.showAlert(message: "Please Enter Contact Person Name")
        }
        else if txtCustomerLocation.text == ""
        {
            self.showAlert(message: "Please Enter Customer Location")
        }
     
        else if txt_SetReminder.text == ""
        {
            self.showAlert(message: "Please set Reminder")
        }
        else if txt_TaskActivity.text == ""
        {
            self.showAlert(message: "Please Enter Task Activity")
        }
        else if startDate.text == ""
        {
            self.showAlert(message: "Please Enter Start Date")
        }
        else if startTime.text == ""
        {
            self.showAlert(message: "Please Enter Start Time")
        }
        else if EndDate.text == ""
        {
            self.showAlert(message: "Please Enter End Date")
        }
        else if EndTime.text == ""
        {
            self.showAlert(message: "Please Enter End Time")
        }
        else if txt_MeetinfStatus.text == ""
        {
            self.showAlert(message: "Please Select Meeting Status")
        }
        else if strMeetingType == ""
        {
            self.showAlert(message: "Please Select Meeting Type")
        }
        else if txt_Remarks.text == ""
        {
            self.showAlert(message: "Please Enter Remarks")
        }
        else
        {
            ApiCalling()
        }
        
        
        
        
        
    }
}
