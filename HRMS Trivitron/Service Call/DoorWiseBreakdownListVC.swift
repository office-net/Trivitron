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
    @IBOutlet weak var btn_ViewDetails: UIButton!
    var ListData:JSON = []
    var ReqID = ""
    var finalSubmit = ""
    var ActionShetArray = ["View In Details","Edit In Details","View Indent Details"]
    var simpleSelectedArray = [String]()
    var ServiceType = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_ViewDetails.isHidden = true
        tbl.delegate = self
        tbl.dataSource = self
        self.title = "Product Wise \(ServiceType) List"
        
       
        if finalSubmit == "1"
        {
            
            ActionShetArray = ["View In Details"]
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APiNumberCheck(ReqID: ReqID, Type: ServiceType)
    }

    @IBAction func btn_ViewDetails(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
        let secondVC = storyboard.instantiateViewController( withIdentifier: "BreakDownEditVC" ) as! BreakDownEditVC
        secondVC.ReqID = self.ReqID
        secondVC.PageServiceType = self.ServiceType
        secondVC.FillIndent = "False"
        secondVC.ServiceID = "0"
        secondVC.typeOfUser = "New"
        self.navigationController?.pushViewController(secondVC, animated: true)
        
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
                secondVC.ReqID = self?.ListData[sender.tag]["ReqID"].stringValue ?? ""
                secondVC.ServiceID = self?.ListData[sender.tag]["ServiceID"].stringValue ?? ""
                switch self?.ServiceType
                {
                case "Installation" :
                    secondVC.PageServiceType = self?.ServiceType ?? ""
                    
                    
                default:
                    secondVC.PageServiceType = self?.ServiceType ?? ""
                }
              self?.navigationController?.pushViewController(secondVC, animated: true)
            case "Edit In Details":
                let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakDownEditVC")as! BreakDownEditVC
                secondVC.FillIndent = "True"
                secondVC.ReqID = self?.ListData[sender.tag]["ReqID"].stringValue ?? ""
                secondVC.ServiceID = self?.ListData[sender.tag]["ServiceID"].stringValue ?? ""
                 secondVC.PageServiceType = self?.ServiceType ?? ""
        
              self?.navigationController?.pushViewController(secondVC, animated: true)
                
            default:
                let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "ViewIndentVC")as! ViewIndentVC
                secondVC.ReqId = self?.ListData[sender.tag]["ReqID"].stringValue ?? ""
                secondVC.ServiceID = self?.ListData[sender.tag]["ServiceID"].stringValue ?? ""
              self?.navigationController?.pushViewController(secondVC, animated: true)
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
            print(response)
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.ListData = response["ServicesPerDoorDetails"]
            
                self.tbl.reloadData()
                self.btn_ViewDetails.isHidden = true
            }
            else
            {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                 
                    self.btn_ViewDetails.isHidden = false
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





