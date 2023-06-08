//
//  ReshchwduleTaskVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 06/06/23.
//

import UIKit
import RSSelectionMenu
import SwiftyJSON

class ReshchwduleTaskVC: UIViewController {

    @IBOutlet weak var btn_Submit: Gradientbutton!
    @IBOutlet weak var btn_SelectReasion: UIButton!
    
    
    @IBOutlet weak var startDate:UITextField!
    @IBOutlet weak var startTime:UITextField!
    @IBOutlet weak var EndDate:UITextField!
    @IBOutlet weak var EndTime:UITextField!
    @IBOutlet weak var Remaeks: UITextField!
    
    var simpleSelectedArray = [String]()
    var ActionArray = ["Postpone By Customer","Cancelled By Customer","Reschedule","Other (Please Specify In remark)"]
    var getData:JSON = []
    var TaskId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UiSetup()
        
    }
    
    @IBAction func btn_Submit(_ sender: Any) {
        let CompareTimes = compareTimeStrings(time1: startTime.text ?? "", time2: EndTime.text ?? "")
        let CheckStartTime = compareTimeStrings(time1: Date.getCurrentTime(), time2: startTime.text ?? "")
        let CheckEndTime = compareTimeStrings(time1: Date.getCurrentTime(), time2: EndTime.text ?? "")
      if CompareTimes
        {
          self.showAlert(message: "Start Time Should be less then End Time ")
        }
       else if CheckStartTime
        {
            self.showAlert(message: "Start Time Should be Greater then Current Time ")
        }
        else if CheckEndTime
        {
            self.showAlert(message: "End Time Should be Greater then Current Time ")
        }
        else if btn_SelectReasion.titleLabel?.text == "---Select Reason---"
        {
            self.showAlert(message: "Please Select Reason For Rescheduling")
        }
        
        
        else
        {
            ApiCalling()
        }
    }

    @IBAction func btn_Selct(_ sender: Any) {
        BtnSelect(Sender: sender as! UIButton)
    }
    func compareTimeStrings(time1: String, time2: String) -> Bool {
        
        //format the times into Date objects
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let time1Object = formatter.date(from: time1)
        let time2Object = formatter.date(from: time2)
        
        //if time1Object is nil or time2Object is nil, then return false
        guard let t1 = time1Object, let t2 = time2Object else { return false }
        
        //Compare the Date objects
        return isTime1LaterThanTime2(time1: t1, time2: t2)
    }

    // Helper method for comparing time1 and time2
    func isTime1LaterThanTime2(time1: Date, time2: Date) -> Bool {
        print("============")
        return time1.compare(time2).rawValue > 0
       
    }
    
    
}


extension ReshchwduleTaskVC
{
    func ApiCalling()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!,"TaskId":getData["TaskId"].stringValue,"Reasonofcancellation":btn_Submit.titleLabel?.text ?? "","StartDate":startDate.text ?? "","StartTime":startTime.text ?? "","EndDate":EndDate.text ?? "","EndTime":EndTime.text ?? "","Remarks":Remaeks.text ?? ""] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RescheduleMeeting", parameters: parameters) { (response,data) in
         
            let status = response["Status"].intValue
            if status == 1
            {
                let msg = response["Message"].stringValue
                // Create the alert controller
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    let navigationController = self.navigationController
                    let viewControllers = navigationController!.viewControllers
                    let count = viewControllers.count
                    let secondLastViewController = viewControllers[count - 3]
                    navigationController!.popToViewController(secondLastViewController, animated:true)
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
                let msg = response["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
}

















extension ReshchwduleTaskVC
{
    func UiSetup()
    {
        base.changeImageCalender(textField: self.startDate)
        base.changeImageCalender(textField: self.EndDate)
        base.changeImageClock(textField: self.EndTime)
        base.changeImageClock(textField: self.startTime)
        
        
        self.startDate.setInputViewDatePicker2(target: self, selector: #selector(tapDonestartDate))
        self.EndDate.setInputViewDatePicker2(target: self, selector: #selector(tapDoneEndDate))
        self.startTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneStartTime))
        self.EndTime.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneEndTime))
        
        startDate.text = getData["STARTS_DATE"].stringValue
        EndDate.text = getData["END_DATE"].stringValue
        
        startTime.text = getData["START_TIME"].stringValue
        EndTime.text = getData["taskEndTime"].stringValue
    }
    func BtnSelect(Sender:UIButton){
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: ActionArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            
          
        }
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, selected, selectedList) in
        self?.simpleSelectedArray = selectedList
    
            self?.btn_SelectReasion.setTitle(text, for: .normal)

    }
        selectionMenu.dismissAutomatically = true

        selectionMenu.show(style: .popover(sourceView: Sender as UIView, size: CGSize(width: 220, height: 200)), from: self)
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
  
}

