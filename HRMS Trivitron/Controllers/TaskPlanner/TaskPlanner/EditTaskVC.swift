//
//  EditTaskVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 07/06/23.
//

import UIKit
import SwiftyJSON

class EditTaskVC: UIViewController,AdditionalPeron, UITextFieldDelegate {
    @IBOutlet weak var txtContactPersonName:UITextField!
    @IBOutlet weak var txtContactPersonNumber:UITextField!
    @IBOutlet weak var txtCustomerLocation: UITextField!
    @IBOutlet weak var txtContactPersonEmail:UITextField!
    @IBOutlet weak var txt_TaskActivity: UITextField!
    @IBOutlet weak var txt_MeetinfStatus: UITextField!
    @IBOutlet weak var btn_PhysicalMeeting: UIButton!
    @IBOutlet weak var btn_VartualMeeting: UIButton!
    @IBOutlet weak var txt_Remarks: UITextField!
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var HieghtTbl:NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var Aname: UITextField!
    @IBOutlet weak var AalternativeNumber: UITextField!
    
    @IBOutlet weak var anumber: UITextField!
    @IBOutlet weak var Adesigination: UITextField!
    @IBOutlet weak var AEmail: UITextField!
   
    
    
    
    var strMeetingType = ""
    var gradePicker: UIPickerView!
    var meetingStatusArray = ["FIXED","TO BE CONFIRMED"]
    
    var getdata:JSON = []
    
    var BackDish = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Uisetup()
        self.title = "Edit Task"
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.txt_MeetinfStatus.delegate = self
        txt_MeetinfStatus.inputView = gradePicker
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UINib(nibName: "AddNewTaskCell", bundle: nil), forCellReuseIdentifier: "AddNewTaskCell")
        
        if getdata["ADDITIONAL_PERSON"].isEmpty
        {
           
        }
        else
        {
            
            
            for i in 0...(self.getdata["ADDITIONAL_PERSON"].count) - 1
            {
                let index = self.getdata["ADDITIONAL_PERSON"][i]
               
                
                let dict = ["PersonName": index["PersonName"].stringValue,
                            "ContactNo":index["ContactNo"].stringValue,
                            "DESIGNATION":index["DESIGNATION"].stringValue,
                            "Email_Id":index["Email_Id"].stringValue,
                            "ID":index["ID"].stringValue,
                            "TYPE":"D",
                            "AlternateMobNo":index["AlternateMobNo"].stringValue] as [String : Any]
                
                BackDish.append(dict)
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    @IBAction func btn_Additional(_ sender: Any) {
    
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let dict = ["PersonName": Aname.text ?? "",
                    "ContactNo":anumber.text ?? "",
                    "DESIGNATION":Adesigination.text ?? "",
                    "Email_Id":AEmail.text ?? "",
                    "ID": UserID!,
                    "TYPE":"D",
                    "AlternateMobNo":AalternativeNumber.text ?? ""] as [String : Any]
        
        BackDish.append(dict)
        tbl.reloadData()
    }
    
    @IBAction func btn_Submit(_ sender: Any) {
        ApiCalling()
    }
    
    
    
    func BtnPressed(tag: Int) {
        BackDish.remove(at: tag)
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
}






extension EditTaskVC
{
    func ApiCalling()
    {
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let params:[String:Any] = ["TokenNo":token!,"UserId":UserID!,
                                   "TaskId":getdata["TaskId"].stringValue,
                                   "CUST_TYPE":getdata["CUST_TYPE"].stringValue,
                                   "COMPANY_ID":getdata["COMPANY_ID"].stringValue,
                                   "CUSTOMER_NAME":getdata["CUSTOMER_NAME"].stringValue,
                                   "ContactPerson":txtContactPersonName.text ?? getdata["ContactPerson"].stringValue,
                                   "CONTACT_NO":txtContactPersonNumber.text ?? getdata["CONTACT_NO"].stringValue,
                                   "EMAIL_ID":txtContactPersonEmail.text ?? getdata["EMAIL_ID"].stringValue,
                                   "CUSTOMER_LOCATION":txtCustomerLocation.text ?? getdata["CUSTOMER_LOCATION"].stringValue,
                                   "SETASREMINDER_TM":getdata["SETASREMINDER_TM"].stringValue,
                                   "TASK_ACTIVITY":txt_TaskActivity.text ?? getdata["TASK_ACTIVITY"].stringValue,
                                   "STARTS_DATE":getdata["STARTS_DATE"].stringValue,
                                   "START_TIME":getdata["START_TIME"].stringValue,
                                   "END_DATE":getdata["END_DATE"].stringValue,
                                   "END_TIME":getdata["END_TIME"].stringValue,
                                   "MEETING_STATUS":txt_MeetinfStatus.text ?? getdata["MEETING_STATUS"].stringValue,
                                   "MEETING_TYPE":strMeetingType,
                                   "REMARKS":txt_Remarks.text ?? getdata["REMARKS"].stringValue,
                                   "ADDITIONAL_PERSON":self.BackDish]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"UpdateTask", parameters: params) { (response,data) in
            let status = response["Status"].intValue
            if status == 1
            {
                print(response)
                let msg = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
            else
            {
                let msg = response["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
           
}
}



extension EditTaskVC
{
    func Uisetup()
    {
        self.txtContactPersonName.text = getdata["ContactPerson"].stringValue
        self.txtContactPersonEmail.text = getdata["EMAIL_ID"].stringValue
        self.txtContactPersonNumber.text = getdata["CONTACT_NO"].stringValue
        self.txtCustomerLocation.text = getdata["CUSTOMER_LOCATION"].stringValue
        
        self.txt_TaskActivity.text = getdata["TASK_ACTIVITY"].stringValue
        self.txt_MeetinfStatus.text = getdata["MEETING_STATUS"].stringValue
        strMeetingType = getdata["MeetingType"].stringValue
        let meetingtype = getdata["MeetingType"].stringValue
        if meetingtype == "Physical Meeting"
        {
            self.btn_PhysicalMeeting.isSelected = true
        }
        else
        {
            btn_VartualMeeting.isSelected = true
        }
        self.txt_Remarks.text = getdata["REMARKS"].stringValue
    }
}















extension EditTaskVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HieghtTbl.constant = CGFloat(BackDish.count*380)
        return BackDish.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewTaskCell", for: indexPath)as! AddNewTaskCell
        cell.name.text = BackDish[indexPath.row]["PersonName"] as? String
        cell.name.isUserInteractionEnabled = false
        cell.number.text = BackDish[indexPath.row]["ContactNo"] as? String
        cell.number.isUserInteractionEnabled = false
        cell.AlternativeMobileNumber.text = BackDish[indexPath.row]["AlternateMobNo"] as? String
        cell.AlternativeMobileNumber.isUserInteractionEnabled = false
        cell.desiginstiomn.text = BackDish[indexPath.row]["DESIGNATION"] as? String
        cell.desiginstiomn.isUserInteractionEnabled = false
        cell.email.text = BackDish[indexPath.row]["Email_Id"] as? String
        cell.email.isUserInteractionEnabled = false
        cell.btn.tag = indexPath.row
        cell.btn.setImage(UIImage(named: "cancel"), for: .normal)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  340
    }
    
}


extension EditTaskVC: UIPickerViewDelegate, UIPickerViewDataSource 
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
