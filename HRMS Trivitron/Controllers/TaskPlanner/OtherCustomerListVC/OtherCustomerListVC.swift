//
//  OtherCustomerListVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 12/06/23.
//

import UIKit
import SwiftyJSON

class OtherCustomerListVC: UIViewController {

    @IBOutlet weak var tbl:UITableView!
    var OtherCustomerList:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select New Customer"
        ApiCallingForMarkVisit()
      
    }
    



}
extension OtherCustomerListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        OtherCustomerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherCustomerCell", for: indexPath) as! OtherCustomerCell
        cell.customername.text = OtherCustomerList[indexPath.row]["CustomerName"].stringValue
        cell.TypeOfIndustry.text = OtherCustomerList[indexPath.row]["CompanyName"].stringValue
        cell.contactPerson.text = OtherCustomerList[indexPath.row]["ContactPersonName"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "NewTaskVC")as! NewTaskVC
        secondVC.TaskType = "New"
        secondVC.CustomerData = OtherCustomerList[indexPath.row]
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    func ApiCallingForMarkVisit()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"OtherCustomerList", parameters: parameters) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {   self.OtherCustomerList = json["OtherCustomerList"]
                self.tbl.reloadData()
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
}


class OtherCustomerCell:UITableViewCell
{
    @IBOutlet weak var customername:UILabel!
    @IBOutlet weak var TypeOfIndustry:UILabel!
    @IBOutlet weak var contactPerson:UILabel!
   
}
