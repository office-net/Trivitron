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
    var EndPoint = ""
    var ServiceType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        
        self.title = "Details List"
        APiNumberCheck(EndPoint: EndPoint)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        self.navigationController?.setNavigationBarHidden(false, animated: true)
          navigationController?.navigationBar.barStyle = .default
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationItem.backBarButtonItem = backButton
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.navigationBar.tintColor = UIColor.black
          self.navigationController?.view.backgroundColor = UIColor.clear
       self.navigationController?.navigationBar.backgroundColor = base.firstcolor
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
     
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
        cell.btn_FinalSubmit.tag = indexPath.row
        cell.btn_FinalSubmit.addTarget(self, action: #selector(btn), for: .touchUpInside)
        return cell
    }
    
    @objc func btn(_sender:UIButton)
    {
        
       
        APiFinalSubmit(ServiceType: self.ServiceType, Index: _sender.tag)
        
        
        
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
        if ServiceType == "Spares"
        {
            let ticketNumber = ListData[indexPath.row]["TicketNo"].stringValue
            let type = ticketNumber.prefix(2)
            switch type
            {
            case "BD":
                secondVC.ServiceType = "Breakdown"
            case "IN":
                secondVC.ServiceType = "Installation"
            case "PE":
                secondVC.ServiceType = "Preventive Maintenance"
            case "AP":
                secondVC.ServiceType = "Application"
            case "TR":
                secondVC.ServiceType = "Training"
            case "OT":
                secondVC.ServiceType = "Others"
            default:
                secondVC.ServiceType = "Spares"
            }
         
            
            
        }
        else
        {
            secondVC.ServiceType = ServiceType
        }
        
       
       
      
        secondVC.ReqID = ListData[indexPath.row]["ReqID"].stringValue
        secondVC.finalSubmit = ListData[indexPath.row]["finalSubmit"].stringValue
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}






extension BreakdownListVC
{
    func APiFinalSubmit(ServiceType:String,Index:Int)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["UserId":UserID!,"TokenNo": token!,"ReqID":ListData[Index]["ReqID"].stringValue,"TicketType":ServiceType] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"FinalSave", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.APiNumberCheck(EndPoint: self.EndPoint)
                    
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
        }
    }
    
    
    func APiNumberCheck(EndPoint:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["UserId":UserID!,"TokenNo": token!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:EndPoint, parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {  print(response)
                 switch self.ServiceType
                {
                case "Installation":
                    self.ListData = response["AmcList"]
                    self.tbl.reloadData()
                    self.title  = "AMC List"
                case "Breakdown":
                    self.ListData = response["BreakdownList"]
                    self.tbl.reloadData()
                    self.title  = "Breakdown List"
                case "Preventive Maintenance":
                    self.ListData = response["ServiceList"]
                    self.tbl.reloadData()
                    self.title  = "Preventive Maintenance List"
                    
                case "Spares":
                    self.ListData = response["SpareList"]
                    self.tbl.reloadData()
                    self.title  = "Spares List"
                    
                case "Application":
                    self.ListData = response["ApplicationList"]
                    self.tbl.reloadData()
                    self.title  = "Application List"
                case "Training":
                    self.ListData = response["TraningList"]
                    self.tbl.reloadData()
                    self.title  = "Training List"
                default:
                    self.ListData = response["OtherList"]
                    self.tbl.reloadData()
                    self.title  = "Others List"
                }
                
               
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
