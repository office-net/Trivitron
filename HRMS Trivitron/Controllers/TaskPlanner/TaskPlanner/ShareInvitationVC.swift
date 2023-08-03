//
//  ShareInvitationVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 08/06/23.
//

import UIKit
import SwiftyJSON


class ShareInvitationVC: UIViewController {
    var GetData:JSON = []
    var TaskID = ""
    var Emp_Code = ""
    var selectedbtn = Int()
    
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Share Invitation"
        tbl.delegate = self
        tbl.dataSource = self
        tbl.separatorStyle = .none
        ApiCalling()
    }
    
    
    @IBAction func btn_Submit(_ sender: Any) {
        if Emp_Code == ""
        {
            self.showAlert(message: "Please Select a Employee first")
        }
        else
        {
            SubmitApi()
        }
    }
    
    func  SubmitApi()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskID,"EmpCodes":Emp_Code] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"ShareMeeting", parameters: parameters) { (response,data) in
            self.GetData = response
            let status = self.GetData["Status"].intValue
            if status == 1
            {
                let msg = self.GetData["Message"].stringValue
                self.showAlertWithAction(message: msg)
            }
            else
            {
                let msg = self.GetData["Message"].stringValue
                
                self.tbl.reloadData()
            }
        }
    }
    
}




extension ShareInvitationVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetData["EmpConList"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell", for: indexPath)as! ShareCell
        cell.name.text =  GetData["EmpConList"][indexPath.row]["Emp_Name"].stringValue
        cell.desigination.text =  GetData["EmpConList"][indexPath.row]["EmpDesignation"].stringValue
        cell.btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btn.tag = indexPath.row
        if selectedbtn ==  indexPath.row
        {
            cell.btn.isSelected = true
            self.Emp_Code = GetData["EmpConList"][indexPath.row]["Emp_Code"].stringValue
        }
        else
        {
            cell.btn.isSelected = false
        }
        return cell
    }
    @objc func buttonTapped(_ sender: UIButton)
    
    {
        self.selectedbtn = sender.tag
        self.tbl.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
}

extension ShareInvitationVC
{
    func ApiCalling()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"EmpTeamList", parameters: parameters) { (response,data) in
            self.GetData = response
            let status = self.GetData["Status"].intValue
            if status == 1
            {
                print(self.GetData)
                self.tbl.reloadData()
                
            }
            else
            {
                let msg = self.GetData["Message"].stringValue
                self.showAlert(message: msg)
                self.tbl.reloadData()
            }
        }
    }
    
}













class ShareCell:UITableViewCell
{
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var desigination: UILabel!
    @IBOutlet weak var btn: UIButton!
}
