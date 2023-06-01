//
//  LeadsAddNotesVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 31/05/23.
//

import UIKit

class LeadsAddNotesVC: UIViewController {
    var LeadId = ""
  
    
    @IBOutlet weak var txt_note: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       print("==========================\(LeadId)")
    }
    
    @IBAction func btn_Submit(_ sender: Any) {
        if txt_note.text == ""
        {
            self.showAlert(message: "Please enter Note ")
        }
        else
        {
            self.ApiCalling()
        }
    }
    
    func ApiCalling()
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!,"UserId": UserID!,"LeadNotes":txt_note.text ?? "","LEAD_ID":LeadId] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"UpdateLeadNotes", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            
            if Status == 1
            {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.dismissSemiModalView()
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
}
