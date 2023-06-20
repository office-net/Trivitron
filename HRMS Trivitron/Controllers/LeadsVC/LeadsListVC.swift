//
//  LeadsListVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 20/07/22.
//

import UIKit
import SwiftyJSON
import Alamofire
import RSSelectionMenu
import SemiModalViewController


class LeadsListVC: UIViewController {
    var getData:JSON = []
    var LeadType:JSON = []
   
    var simpleSelectedArray = [String]()
    var ActionArray = ["View-Details","Edit","Re-classify","Add-Notes","Set-Meeting","Upload/View/Document"]
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leads List"
        apicalling()
        ApiCallingMaster()
    }
  
    
    @IBAction func BTN_New(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsFormVC")as! LeadsFormVC
        
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
          navigationController?.navigationBar.barStyle = .default
          self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
          self.navigationController?.navigationBar.tintColor = UIColor.black
          self.navigationController!.view.backgroundColor = UIColor.clear
       self.navigationController?.navigationBar.backgroundColor = base.firstcolor
          self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        
    }
    
  

}






extension LeadsListVC
{
    func ApiCallingMaster()
    
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!,"UserId": UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LeadMasterSpinner", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.LeadType = response["LeadStatus"]
                print(self.LeadType)
              
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
}






extension LeadsListVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "leadsCell", for: indexPath) as! leadsCell
        cell.lbl_cName.text = getData[indexPath.row]["LEAD_NAME"].stringValue
        cell.lbl_Industry.text = getData[indexPath.row]["CATE_OF_INDUSTRYN"].stringValue
        cell.lbl_CPerson.text = getData[indexPath.row]["CONTACT_PERSON_NAME"].stringValue
        cell.lbl_Date.text = getData[indexPath.row]["CREATEDDT"].stringValue
        cell.btn.tag = indexPath.row
        cell.btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return cell
    }
    @objc func buttonTapped(_ sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: ActionArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name.components(separatedBy: " ").first
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
          
        }
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, selected, selectedList) in
        self?.simpleSelectedArray = selectedList
       let value = text
        
        
        switch value {
        case "View-Details":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsFormVC")as! LeadsFormVC
            secondVC.DetailsJson = JSON(rawValue: (self?.getData[sender.tag])!)!
            
            secondVC.IsFromViewDetails = "View"
           
            self?.navigationController?.pushViewController(secondVC, animated: true)
        case "Edit":
            self?.FromEdit(Tag: sender.tag)
     
        case "Re-classify":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadReClassifyVC")as! LeadReClassifyVC
            secondVC.LeadId = (self?.getData[sender.tag]["LeadNo"].stringValue)!
            secondVC.MasterData = JSON(rawValue: (self?.LeadType)!)!
            secondVC.BackData = JSON(rawValue: (self?.getData[sender.tag])!)!
            self?.navigationController?.pushViewController(secondVC, animated: true)
            
        case "Set-Meeting":
          
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "NewTaskVC")as! NewTaskVC
            secondVC.TaskType = "Lead"
            secondVC.CustomerData = JSON(rawValue: (self?.getData[sender.tag])!)!
    
            self?.navigationController?.pushViewController(secondVC, animated: true)

        case "Add-Notes":
            self?.simpleSelectedArray = [String]()
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "LeadsAddNotesVC") as! LeadsAddNotesVC
            pvc.LeadId = (self?.getData[sender.tag]["LeadNo"].stringValue)!
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
            
            pvc.modalPresentationStyle = .overCurrentContext
            self?.presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
        case "Upload/View/Document":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsUploadAndViewDocVC")as! LeadsUploadAndViewDocVC
            secondVC.LeadId = (self?.getData[sender.tag]["LeadNo"].stringValue)!
            self?.navigationController?.pushViewController(secondVC, animated: true)
            
       
        default:
            print("Unknown player")
         }

    }
        selectionMenu.dismissAutomatically = true

        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 200, height: 265)), from: self)
        
      }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    
    
    
    
    
    func FromEdit(Tag:Int)
    {
        self.simpleSelectedArray = [String]()
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "LeadsFormVC")as! LeadsFormVC
        secondVC.DetailsJson = self.getData[Tag]
        secondVC.IsFromViewDetails = "Edit"
        
       
        
        
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension LeadsListVC
{
    func apicalling()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
         let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
     
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int  {
            parameters = [ "TokenNo": token!,
                           "UserId": UserID,
                           "ddllocation": "",
                           "search": "",
                           "Location": "",
                           "PPROD_OF_INTEREST": "0",
                           "leadtype": "0",
                           "Status": "0",
                           "PCATE_OF_INDUSTRY": "0",
                           "REGIONID": "0",
                           "MOBILENO": ""]
          
        }
        else{
            parameters = ["TokenNo":"06736D3D-5E8B-491E-875C-255ED9A229A6","UserId":0]
        }
        
        AF.request( base.url+"LeadCustomerList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(value)
        
                   // print(json)
                    print(response.request!)
                    print(parameters!)
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        self.getData =  json["LeadCustomerlst"]
                    
                        self.tbl.reloadData()
                    }
                    else
                    {
                        let msg = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                           // self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            
                        self.present(alertController, animated: true)
                        }
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
        
        
    }
    
    
    
   

    
  
    
    
}





class leadsCell:UITableViewCell
{
    
   
    @IBOutlet weak var lbl_cName: UILabel!
    
    @IBOutlet weak var lbl_Industry: UILabel!
    @IBOutlet weak var lbl_CPerson: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
