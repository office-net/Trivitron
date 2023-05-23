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
        ListApiCalling()
       
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
