//
//  DoorWiseBreakdownListVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 26/06/23.
//

import UIKit
import SwiftyJSON
import RSSelectionMenu

class DoorWiseBreakdownListVC: UIViewController {
    @IBOutlet weak var tbl:UITableView!
    var ListData:JSON = []
    var ReqID = ""
    var finalSubmit = ""
    var ActionShetArray = ["View In Details","Edit In Details","Download Indent File"]
    var simpleSelectedArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        self.title = " Door Wise Breakdown List"
        APiNumberCheck(ReqID: ReqID, Type: "Breakdown")
        
        if finalSubmit == "1"
        {
            ActionShetArray = ["View In Details"]
        }
    }
    

 

}

extension DoorWiseBreakdownListVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoorWiseBreakdownListCell", for: indexPath) as! DoorWiseBreakdownListCell
        cell.assignedEmployee.text = ": " + ListData[indexPath.row]["AssignedEmpTO"].stringValue
        cell.ServiceReport.text = ": " + ListData[indexPath.row]["ServiceReportNo"].stringValue
        cell.StageDate.text = ": " + ListData[indexPath.row]["StageDate"].stringValue
        cell.StageStatus.text = ": " + ListData[indexPath.row]["StageStatus"].stringValue
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    @objc func buttonTapped(_ sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: ActionShetArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            
            
        }
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, selected, selectedList) in
            self?.simpleSelectedArray = selectedList
            let value = text
            
            
            switch value {
            case "View In Details":
                let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakDownViewDetailsVC")as! BreakDownViewDetailsVC
              self?.navigationController?.pushViewController(secondVC, animated: true)
            case "Edit":
                print("Edit")
                
            default:
                print("Unknown player")
            }
            
        }
        selectionMenu.dismissAutomatically = true
        
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 200, height: self.ActionShetArray.count * 40)), from: self)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}

extension DoorWiseBreakdownListVC
{
    func APiNumberCheck(ReqID:String,Type:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!,"ReqID":ReqID,"Type":Type] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"ServicesPerDoorDetails", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.ListData = response["ServicesPerDoorDetails"]
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


class DoorWiseBreakdownListCell:UITableViewCell
{
    
    @IBOutlet weak var assignedEmployee: UILabel!
    @IBOutlet weak var ServiceReport: UILabel!
    @IBOutlet weak var StageDate: UILabel!
    @IBOutlet weak var StageStatus: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}




