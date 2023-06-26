//
//  BreakdownListVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 22/06/23.
//

import UIKit
import SwiftyJSON

class BreakdownListVC: UIViewController {
    @IBOutlet weak var tbl:UITableView!
    var ListData:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        self.title = "Breakdown List"
        APiNumberCheck()

    }
    
    
    
}


extension BreakdownListVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreakdownListCell", for: indexPath) as! BreakdownListCell
        cell.TicketNumber.text = ": " + ListData[indexPath.row]["TicketNo"].stringValue
        cell.DateAndTime.text = ": " + ListData[indexPath.row]["TicketDate"].stringValue + " " + ListData[indexPath.row]["Tickettime"].stringValue
        cell.CustomerName.text = ": " + ListData[indexPath.row]["CustomerName"].stringValue
        cell.IndustryCatagory.text = ": " + ListData[indexPath.row]["IndustryCategoryName"].stringValue
        if cell.IndustryCatagory.text == ": "
        {
            cell.IndustryCatagory.text = ": " + "Not Available"
        }
        let finalSubmit = ListData[indexPath.row]["finalSubmit"].intValue
        if finalSubmit == 1
        {
            cell.btn_FinalSubmit.isHidden = true
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let finalSubmit = ListData[indexPath.row]["finalSubmit"].intValue
        if finalSubmit == 1
        {
            return 140
            
        }
        else
        {
            
            return 180
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "DoorWiseBreakdownListVC")as! DoorWiseBreakdownListVC
        secondVC.ReqID = ListData[indexPath.row]["ReqID"].stringValue
        secondVC.finalSubmit = ListData[indexPath.row]["finalSubmit"].stringValue
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}






extension BreakdownListVC
{
    func APiNumberCheck()
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["UserId":UserID!,"TokenNo": token!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"BreakdownList", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.ListData = response["BreakdownList"]
                self.tbl.reloadData()
            }
            else
            {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
            
            
            
        }
    }
}






class BreakdownListCell:UITableViewCell
{
    @IBOutlet weak var TicketNumber:UILabel!
    @IBOutlet weak var DateAndTime:UILabel!
    @IBOutlet weak var CustomerName:UILabel!
    @IBOutlet weak var IndustryCatagory:UILabel!
    @IBOutlet weak var btn_FinalSubmit:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
