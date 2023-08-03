//
//  LeadReClassifyVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 23/05/23.
//

import UIKit
import SwiftyJSON
import Alamofire

class LeadReClassifyVC: UIViewController {
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var btnsaVE:UIButton!
    @IBOutlet weak var LeadStatus:UITextField!
    @IBOutlet weak var Remarks:UITextField!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var hh: NSLayoutConstraint!
    @IBOutlet weak var NoRecordFound: UILabel!
    var MasterData:JSON = []
    var StatusDetailsList:JSON = []
    var BackData:JSON = []
    var StatusId:String = ""
    var LeadId = ""
    var gradePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lead Re-classify"
        NoRecordFound.isHidden = true
        tbl.dataSource = self
        tbl.delegate =  self
        tbl.separatorStyle = .none
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        LeadStatus.delegate = self
        LeadStatus.inputView = gradePicker
        
        
        self.vv.isHidden = true
        self.hh.constant = 0
        
        ListApiCalling()
        
    }
    
    @IBAction func btn_Save(_ sender: Any) {
        if Remarks.text == ""
        {
            self.showAlert(message: "Please enter remarks")
        }
        else if LeadStatus.text == "-Selected-"
        {
            self.showAlert(message: "Please Select Lead Status")
        }
        else if  LeadStatus.text == "-Select-"
        {
            self.showAlert(message: "Please Select Lead Status")
        }
        else if LeadStatus.text == ""
        {
            self.showAlert(message: "Please Select Lead Status")
        }
        else
        {
            switch LeadStatus.text
            {
            case "Won":
                APiCalling(Quotation: "", AppropriateValue: txt.text ?? "", LostRemarks: "")
            case "Lost":
                APiCalling(Quotation: "", AppropriateValue:"", LostRemarks: txt.text ?? "")
            default :
                APiCalling(Quotation: "", AppropriateValue: "", LostRemarks: "")
            }
        }
    }
    
}
extension LeadReClassifyVC:UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        MasterData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return MasterData[row]["Name"].stringValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        LeadStatus.text =  MasterData[row]["Name"].stringValue
        StatusId =  MasterData[row]["Id"].stringValue
        
        switch LeadStatus.text
        {
        case "Quotation Submitted":
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerDetailsFormVC")as! CustomerDetailsFormVC
            vc.BackData = self.BackData
            vc.backLeadId = self.LeadId
            vc.isFrom = "Re-Clasify"
            self.navigationController?.pushViewController(vc, animated: true)
        case "Won":
            self.vv.isHidden = false
            self.hh.constant = 70
            self.lbl.text = "Appropriate Value"
            
        case "Lost":
            self.vv.isHidden = false
            self.hh.constant = 70
            self.lbl.text = "Lost Remarks"
        default:
            self.vv.isHidden = true
            self.hh.constant = 0
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == LeadStatus
        {
            let dropDown = textField.inputView as? UIPickerView
            dropDown?.selectRow(0, inComponent: 0, animated: true)
            LeadStatus.text =  MasterData[0]["Name"].stringValue
            StatusId = MasterData[0]["Id"].stringValue
            
        }
        
        return true
    }
    func APiCalling(Quotation:String,AppropriateValue:String,LostRemarks:String)
    
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters = [String : Any]()
        parameters = ["IsCustomerBase":"No","TokenNo":token!,"UserId":UserID!,"LeadStatusId":StatusId,"Remarks":Remarks.text ?? "","LeadId":self.LeadId,"Quotation":Quotation,"AppropriateValue":AppropriateValue,"LostRemarks":LostRemarks,"CustomerCode":"","AllocatedToEmpID":"","CustomerName":"","ContactPersonName":"","ContactPersonMobileNo":"","ContactPersonEmailID":"","AlternateContactPersonName":"","AlternateContactPersonMobileNo":"","AlternateContactPersonEmailID":"","CustomerWebsite":"","Country":"","StateProvince":"","City":"","PostalCode":"","BillingAddress":"","ShippingAddress":"","TrivitronInstallation":"","BusinessUnit":"","Department":"","SubDepartment":"","Status":"","CusBaseRemarks":"","REQID":"0","Region":"0"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SaveReclassifySTS", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if Status == 1
            {
                
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                    
                    self.LeadStatus.text = ""
                    self.Remarks.text = ""
                   self.txt.text = ""
                    
                    self.ListApiCalling()
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











extension LeadReClassifyVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StatusDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellReClassFy", for: indexPath)as! CellReClassFy
        cell.Remarks.text = StatusDetailsList[indexPath.row]["Remarks"].stringValue
        cell.CreatedBy.text = StatusDetailsList[indexPath.row]["CreatedBy"].stringValue
        cell.AppropriateValue.text = StatusDetailsList[indexPath.row]["AppropriateValue"].stringValue
        cell.CreatedDate.text = StatusDetailsList[indexPath.row]["CreatedDate"].stringValue
        cell.StatusType.text = StatusDetailsList[indexPath.row]["StatusType"].stringValue
        cell.Quatation.text = StatusDetailsList[indexPath.row]["Quatation"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}

extension LeadReClassifyVC
{
    func ListApiCalling()
    {
        
        
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!,"LeadId":LeadId] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LMReclassifySTS", parameters: parameters) { (response,data) in
            //print(response)
            let Status = response["Status"].intValue
            if Status == 1
            {   self.StatusDetailsList = response["StatusDetailsList"]
                self.tbl.reloadData()
                self.tbl.isHidden = false
                self.NoRecordFound.isHidden = true
                
            }
            else
            {
                self.tbl.isHidden = true
                self.NoRecordFound.isHidden = false
            }
            
            
            
        }
        
        
        
        
        
    }
}

class CellReClassFy:UITableViewCell
{
    @IBOutlet weak var StatusType:UILabel!
    @IBOutlet weak var Quatation:UILabel!
    @IBOutlet weak var AppropriateValue:UILabel!
    @IBOutlet weak var Remarks:UILabel!
    @IBOutlet weak var CreatedBy:UILabel!
    @IBOutlet weak var CreatedDate:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
