//
//  TaskPlannerETaVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 07/06/23.
//

import UIKit
import SemiModalViewController

class TaskPlannerETaVC: UIViewController {
var TaskId = ""
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        base.changeImageClock(textField: self.txt)
        self.txt.setInputViewDateTimePicker(target: self, selector: #selector(tapDonestartDate))
        self.txt.text = Date.getCurrentTime()
        
    }
    
    @objc func tapDonestartDate() {
        if let datePicker = self.txt.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "HH:mm:ss"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.txt.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt.resignFirstResponder() // 2-5
    }

    @IBAction func btn(_ sender: Any) {
        
        self.ApiCalling()
    }
    
    @IBAction func btn_Close(_ sender: Any) {
        self.dismissSemiModalView()
    }
    
    
    func ApiCalling()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!,"TaskId":TaskId,"ETATime":txt.text ?? ""] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"MarkETA", parameters: parameters) { (response,data) in
         
            let status = response["Status"].intValue
            if status == 1
            {  self.dismissSemiModalView()
                let msg = response["Message"].stringValue
                self.showAlert(message: msg)
               
                    
                }
            else
            {
                let msg = response["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    }



