//
//  Expense_Select_Request.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 21/09/23.
//

import UIKit
import SwiftyJSON

class Expense_Select_Request: UIViewController {
    @IBOutlet weak var txt_Select_request: UITextField!
    @IBOutlet weak var Travel_Type: UILabel!
    @IBOutlet weak var FromDate: UITextField!
    @IBOutlet weak var Todate: UITextField!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var Hieght_View: NSLayoutConstraint!
    @IBOutlet weak var vv: UIView!
    var DeviceHieght = CGFloat()
    var MasterData:JSON = []
    var TravelList:JSON = []
    var gradePicker: UIPickerView!
    
    var RequestId = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        UiSetup()

    }
    
    @IBAction func btn_Claim_Your_Expense(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Travel_Expense", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Expense_Select_Catagory")as! Expense_Select_Catagory
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    


}


extension Expense_Select_Request:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TravelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expense_RequestionCell", for: indexPath) as! expense_RequestionCell
        cell.Departure_Date.text = TravelList[indexPath.row]["DepDate"].stringValue
        cell.Departure_Time.text = TravelList[indexPath.row]["DepTime"].stringValue
        cell.Arrival_Date.text = TravelList[indexPath.row]["ArrDate"].stringValue
        cell.Arrival_Time.text = TravelList[indexPath.row]["ArrTime"].stringValue
        cell.Departure_City.text = TravelList[indexPath.row]["DepCity"].stringValue
        cell.Arr_City.text = TravelList[indexPath.row]["ArrCity"].stringValue
        cell.Mode.text = TravelList[indexPath.row]["Mode"].stringValue
        cell._Class.text = TravelList[indexPath.row]["Class"].stringValue
        cell.name.text = TravelList[indexPath.row]["Name"].stringValue
        cell.Remark.text = TravelList[indexPath.row]["Remark"].stringValue
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
}








extension Expense_Select_Request
{
    func UiSetup()
    {
        tbl.delegate = self
        tbl.dataSource =  self
        base.changeImageCalender(textField: self.Todate)
        base.changeImageCalender(textField: self.FromDate)
        
        self.DeviceHieght = UIScreen.main.bounds.height - 150
        self.Hieght_View.constant = 0
        vv.isHidden = true
        ApiMaster()
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        txt_Select_request.delegate = self
        txt_Select_request.inputView = gradePicker
    }
}








extension Expense_Select_Request:UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MasterData["RequisitionList"].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
            return MasterData["RequisitionList"][row]["Value"].stringValue
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        txt_Select_request.text =  MasterData["RequisitionList"][row]["Value"].stringValue
        RequestId =  MasterData["RequisitionList"][row]["ID"].stringValue
        ApiRequestDetails(RequestNumber: self.RequestId)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if  textField == txt_Select_request
        {
            txt_Select_request.text =  MasterData["RequisitionList"][0]["Value"].stringValue
            RequestId =  MasterData["RequisitionList"][0]["ID"].stringValue
            ApiRequestDetails(RequestNumber: self.RequestId)
        }
        return true
    }
}








extension Expense_Select_Request
{
    func ApiMaster()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
          let parameters = ["TokenNo":token!,"UserID":UserID!] as [String : Any]
         Networkmanager.postRequest(vv: self.view, remainingUrl:"TCMaster_List", parameters: parameters) { (response,data) in
             // print(response)
             let Status = response["Status"].intValue
             if Status == 1
             {
                 self.MasterData = response
             }
             else
             {  let Msg = response["Message"].stringValue
                 self.showAlert(message: Msg)
                
             }
         }
  
     }
    
    func ApiRequestDetails(RequestNumber:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserID":UserID!,"TRID":RequestNumber] as [String : Any]
         Networkmanager.postRequest(vv: self.view, remainingUrl:"TCRequisition_Details", parameters: parameters) { (response,data) in
              print(response)
             let Status = response["Status"].intValue
             if Status == 1
             {
                 self.TravelList = response["TravelData"]
                 self.tbl.reloadData()
                 self.Hieght_View.constant = self.DeviceHieght
                 self.vv.isHidden = false
                 self.FromDate.text = response["fromDate"].stringValue
                 self.Todate.text = response["ToDate"].stringValue
                 self.Travel_Type.text = response["TourType"].stringValue
             }
             else
             {  let Msg = response["Message"].stringValue
                 self.showAlert(message: Msg)
                
             }
         }
  
     }
}


class expense_RequestionCell:UITableViewCell
{
    @IBOutlet weak var Departure_Date: UILabel!
    @IBOutlet weak var Departure_Time: UILabel!
    @IBOutlet weak var Arrival_Date: UILabel!
    @IBOutlet weak var Arrival_Time: UILabel!
    
    
   

    @IBOutlet weak var Mode: UILabel!
    @IBOutlet weak var _Class: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var Remark: UILabel!
    @IBOutlet weak var Departure_City: UILabel!
    @IBOutlet weak var Arr_City: UILabel!
    
}
