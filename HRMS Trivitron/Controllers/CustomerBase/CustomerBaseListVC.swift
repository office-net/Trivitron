//
//  CustomerBaseListVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 31/05/23.
//

import UIKit
import SwiftyJSON

class CustomerBaseListVC: UIViewController {
    
    var getData:JSON = []
    var isFrom = ""
    @IBOutlet weak var btn_New: UIButton!
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customer Base List"
        ApiCallingMaster()
        btn_New.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_New(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsFormVC")as! CustomerDetailsFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

}










extension CustomerBaseListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
        cell.C_Name.text = getData[indexPath.row]["CustomerName"].stringValue
        cell.C_Status.text = getData[indexPath.row]["ContactStatus"].stringValue
        cell.contactPersonName.text = getData[indexPath.row]["Contactpersonname"].stringValue
        cell.Btn_Active_Inactive.setTitle(getData[indexPath.row]["ContactStatus"].stringValue, for: .normal)
        cell.Btn_Active_Inactive.tag = indexPath.row
        cell.Btn_Active_Inactive.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        cell.btnViewDetails.tag = indexPath.row
        cell.btnViewDetails.addTarget(self, action: #selector(buttonTappedViewDetails(_:)), for: .touchUpInside)
        
        cell.btn_SetMeeting.addTarget(self, action: #selector(buttonSetmeeting(_:)), for: .touchUpInside)
        cell.btn_SetMeeting.tag = indexPath.row
        let btnStaTUS = getData[indexPath.row]["IsActionButton"].intValue
        cell.Btn_Active_Inactive.isHidden = btnStaTUS == 0
        if isFrom == "Task Planner"
        {
            cell.btnViewDetails.isHidden = true
            cell.Btn_Active_Inactive.isUserInteractionEnabled = false
            self.btn_New.isHidden = true
            self.title = "Select Exiting Customer"
            
        }
        else
        {
            cell.btn_SetMeeting.isHidden = true
        }
        
        cell.Btn_Active_Inactive.isHidden = true
        return cell
    }
    @objc func buttonSetmeeting(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "NewTaskVC")as! NewTaskVC
        secondVC.CustomerData = getData[sender.tag]
        secondVC.TaskType = "Existing Customer"
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        self.ApiCallingActive(ReqId: getData[sender.tag]["Reqid"].stringValue)
        
    }
    @objc func buttonTappedViewDetails(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsFormVC")as! CustomerDetailsFormVC
        secondVC.isFrom = "View"
        secondVC.ReqID = getData[sender.tag]["Reqid"].stringValue
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    
    
    
}









extension CustomerBaseListVC
{
    func ApiCallingMaster()
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!, "UserId": UserID!,"REGIONID": "0",
                          "Status": "",
                          "SalesOffice": "",
                          "Searchtxt": ""] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CustomerBaseList", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
              
                self.getData =  response["CustomerBaselst"]
            
                self.tbl.reloadData()
              
                
            }
            else
            {      let msg = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                  //  self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    
                self.present(alertController, animated: true)
                }
            }
            
            
            
        }
    }
    
    
    func ApiCallingActive( ReqId:String)
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!, "UserId": UserID!,"Reqid":ReqId] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"ActiveInActive", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if Status == 1
            {
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.ApiCallingMaster()
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    
                self.present(alertController, animated: true)
                }
            }
            else
            {
                self.showAlert(message: msg)
            }
            
            
            
        }
    }
    
    
}




class CustomerCell:UITableViewCell
{
    @IBOutlet weak var C_Name: UILabel!
    @IBOutlet weak var C_Status: UILabel!
    @IBOutlet weak var contactPersonName: UILabel!
    
    @IBOutlet weak var Btn_Active_Inactive: UIButton!
    @IBOutlet weak var btnViewDetails: UIButton!
    
    @IBOutlet weak var btn_SetMeeting: UIButton!
    
}
