//
//  Local_Details.swift
//  HRMS Trivitron
//
//  Created by Ankit Rana  on 29/09/23.
//

import UIKit
import SwiftyJSON

class Local_Details: UIViewController {
    
    @IBOutlet weak var tbl1: UITableView!
    @IBOutlet weak var tbl2: UITableView!
    @IBOutlet weak var Hieght_tbl_1: NSLayoutConstraint!
    @IBOutlet weak var Hieght_Tbl_2: NSLayoutConstraint!
    @IBOutlet weak var Hieght_Remarks: NSLayoutConstraint!
    @IBOutlet weak var Hieght_RM: NSLayoutConstraint!
    @IBOutlet weak var Hirght_Regional: NSLayoutConstraint!
    @IBOutlet weak var Hieght_Finance: NSLayoutConstraint!
    
    @IBOutlet weak var Emp_Code: UILabel!
    
    @IBOutlet weak var Name:UILabel!
    @IBOutlet weak var Department:UILabel!
    @IBOutlet weak var Location:UILabel!
    @IBOutlet weak var Grade:UILabel!
    @IBOutlet weak var Region:UILabel!
    @IBOutlet weak var BusinessUnit:UILabel!
    
    @IBOutlet weak var Req_No:UILabel!
    @IBOutlet weak var Country:UILabel!
    @IBOutlet weak var City:UILabel!
    @IBOutlet weak var Cost_Center:UILabel!
    @IBOutlet weak var Currency:UILabel!
    @IBOutlet weak var txt_Remark: UITextField!
    
    @IBOutlet weak var RM_Satatus:UILabel!
    @IBOutlet weak var RM_Date:UILabel!
    @IBOutlet weak var RM_Remarks:UILabel!

    @IBOutlet weak var Regional_Satatus:UILabel!
    @IBOutlet weak var Regional_Date:UILabel!
    @IBOutlet weak var Regional_Remarks:UILabel!
    
    @IBOutlet weak var Finance_Satatus:UILabel!
    @IBOutlet weak var Finance_Date:UILabel!
    @IBOutlet weak var Finance_Remarks:UILabel!
    
    
    
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var btn_Approve: UIButton!
    @IBOutlet weak var btn_Disapprove: UIButton!
    
    var MsicellaneousAmount = [[String:Any]]()
    var TravelAmount = [[String:Any]]()
    var LCID = ""
    var getData:JSON = []
    var isFrom = ""
    var EditableType = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Local Details"
        UiSetup()
        
    }
    
    @IBAction func btn_Cancel(_ sender: Any) {
        if txt_Remark.text == ""
        {
            self.showAlert(message: "Please Enter Remarks!")
        }
        else
        {
            Apicalling(Status: "3", message: "Are you sure you want to cancel the request?")
        }
    }
    
    @IBAction func btn_Approve(_ sender: Any) {
        if txt_Remark.text == ""
        {
            self.showAlert(message: "Please Enter Remarks!")
        }
        else
        {
            Apicalling(Status: "1", message: "Are you sure you want to Approve the request?")
        }
    }
    
    @IBAction func btn_disapprove(_ sender: Any) {
        if txt_Remark.text == ""
        {
            self.showAlert(message: "Please Enter Remarks!")
        }
        else
        {
            Apicalling(Status: "2", message: "Are you sure you want to Disapprove the request?")
        }
    }
}


extension Local_Details
{
    func Apicalling(Status:String,message:String) {
        let alertController = UIAlertController(title: "Trivitron", message: message, preferredStyle: .alert)

        // First action
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.APi_Action(Status: Status)
        }
        
        let action2 = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction) in
           print("Teri gand me dum nahi hai")
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
       self.present(alertController, animated: true, completion: nil)
    }
    
    func APi_Action(Status:String)
    
    {
        self.Get_Travel_Ammpount()
        self.Get_MIs_Ammount()
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
   
        let parameters = [    "Remarks": txt_Remark.text ?? "",
                              "TokenNo": token!,
                              "TravelAmountRMFinance": "0",
                              "UserID": UserID!,
                              "Status": Status,
                              "LCID": self.LCID,
                              "MsicellaneousAmount": MsicellaneousAmount,
                              "TravelAmount": TravelAmount,
                              "AppType": self.EditableType] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Update_LCStatus", parameters: parameters) { (response,data) in
            print(response)
            let Status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if Status == 1
            {
                self.showAlertWithAction(message: msg)
            }
            else
            {
                self.showAlert(message: msg)
            }
        }
    
        
    }
    
    func Get_Travel_Ammpount()
    {    if getData["LCTravelData"].count != 0
        {
        for i in 0...getData["LCTravelData"].count - 1
        {
            let index = IndexPath(row: i, section: 0)
            let cell: local_Details_Cell1 = self.tbl1.cellForRow(at: index) as! local_Details_Cell1
            if cell.Approve_Ammount.text != ""
            {
                let dic = ["Eligibility": "",
                           "ID": getData["LCTravelData"][index.row]["Id"].stringValue,
                           "Value": cell.Approve_Ammount.text!]
                self.TravelAmount.append(dic)
            }
            
            
        }
    }
    }
    
    func Get_MIs_Ammount()
    {    if getData["LCMiscellaneousData"].count != 0
        {
        for i in 0...getData["LCMiscellaneousData"].count - 1
        {
            let index = IndexPath(row: i, section: 0)
            let cell: local_Details_Cell2 = self.tbl2.cellForRow(at: index) as! local_Details_Cell2
            if cell.Approved_Ammount.text != ""
            {
                let dic = ["Eligibility": "",
                           "ID": getData["LCMiscellaneousData"][index.row]["Id"].stringValue,
                           "Value": cell.Approved_Ammount.text!]
                self.MsicellaneousAmount.append(dic)
            }
            
            
        }
    }
    }
}
























extension Local_Details:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if tableView == tbl1
        { Hieght_tbl_1.constant = CGFloat(getData["LCTravelData"].count * 300)
           return getData["LCTravelData"].count }
        else
        {   Hieght_Tbl_2.constant = CGFloat(getData["LCMiscellaneousData"].count * 245)
            return getData["LCMiscellaneousData"].count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl1
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "local_Details_Cell1", for: indexPath) as! local_Details_Cell1
            cell.date.text = getData["LCTravelData"][indexPath.row]["LDATE"].stringValue
            cell.expense_Type.text = getData["LCTravelData"][indexPath.row]["EXPENSETYPE"].stringValue
            cell.Mode.text = getData["LCTravelData"][indexPath.row]["MODE"].stringValue
            cell.PaidBY.text = getData["LCTravelData"][indexPath.row]["PAIDBY"].stringValue
            cell.KM.text = getData["LCTravelData"][indexPath.row]["KM"].stringValue
            cell.Eligibility.text = getData["LCTravelData"][indexPath.row]["TA_ELIGIBILITY"].stringValue
            cell.Ammount.text = getData["LCTravelData"][indexPath.row]["AMOUNT"].stringValue
            cell.Total_Ammount.text =  " \(indexPath.row + 1) ) Total Ammount  :" +  getData["LCTravelData"][indexPath.row]["AMOUNT"].stringValue
            if self.EditableType == "ACC" {
                cell.Approve_Ammount.isUserInteractionEnabled = true
            }
            else
            {
                cell.Approve_Ammount.isUserInteractionEnabled = false
            }
           
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "local_Details_Cell2", for: indexPath) as! local_Details_Cell2
            cell.Date.text =  getData["LCMiscellaneousData"][indexPath.row]["Date"].stringValue
            cell.ammount.text =  getData["LCMiscellaneousData"][indexPath.row]["AMOUNT"].stringValue
            cell.expense_Type.text =  getData["LCMiscellaneousData"][indexPath.row]["Type"].stringValue
            cell.particular.text =  getData["LCMiscellaneousData"][indexPath.row]["PARTICULAR"].stringValue
            cell.Approved_Ammount.text =  getData["LCMiscellaneousData"][indexPath.row]["ApprovedAmount"].stringValue
            cell.total_Ammount.text =  " \(indexPath.row + 1) ) Total Ammount  :" +  getData["LCMiscellaneousData"][indexPath.row]["AMOUNT"].stringValue
            if self.EditableType == "ACC" {
                cell.Approved_Ammount.isUserInteractionEnabled = true
            }
            else
            {
                cell.Approved_Ammount.isUserInteractionEnabled = false
            }
           
            return cell
            
        }
         }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl1
        {
            Hieght_tbl_1.constant = CGFloat(300 * getData["LCTravelData"].count)
            return 300
        }
       else
        {
            Hieght_Tbl_2.constant = CGFloat(245 * getData["LCMiscellaneousData"].count)
            return 245
        }
    }
}






















extension Local_Details
{
    func UiSetup()
    {
        tbl1.delegate = self
        tbl1.dataSource = self
        tbl2.delegate = self
        tbl2.dataSource = self
        self.APiCalling_RequestDEtails(LCID: self.LCID)
        switch isFrom
        {
        case "Userview" :
            btn_Approve.isHidden = true
            btn_Disapprove.isHidden = true
            txt_Remark.isHidden = true
            Hieght_Remarks.constant = 0
        case "Pending" :
            btn_Cancel.isHidden = true
            Hieght_Remarks.constant = 40
        default:
            btn_Approve.isHidden = true
            btn_Disapprove.isHidden = true
            btn_Cancel.isHidden = true
            txt_Remark.isHidden = true
            Hieght_Remarks.constant = 0
        }
    }
    
    
    
    func APiCalling_RequestDEtails(LCID:String)
    
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserID":UserID!,"LCID":LCID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"LCRequest_Details", parameters: parameters) { (response,data) in
            
            let Status = response["Status"].intValue
            if Status == 1
            {  print(response)
                self.getData = response
               
                self.SetValues(Vale: response)
                self.EditableType = response["AppType"].stringValue
                let IsCancelButton = response["IsCancelButton"].intValue
                if IsCancelButton == 1
                {
                    self.btn_Cancel.isHidden = false
                }
                else
                {
                    self.btn_Cancel.isHidden = true
                }
                self.tbl1.reloadData()
                self.tbl2.reloadData()
                
            }
            else
            {
                let msg = response["Message"].stringValue
                self.showAlertWithAction(message: msg)
            }
        }
    }
    
    
    
    
    
    
    
    
    func SetValues(Vale:JSON)
    {
        Emp_Code.text = Vale["empCode"].stringValue
        Name.text = Vale["emplyeeName"].stringValue
        Department.text = Vale["department"].stringValue
        Location.text = Vale["location"].stringValue
        Grade.text = Vale["grade"].stringValue
        Region.text = Vale[""].stringValue
        BusinessUnit.text = Vale["UNIT_NAME"].stringValue
        
        Req_No.text = Vale["reqno"].stringValue
        Country.text = Vale["COUNTRY"].stringValue
        City.text = Vale["CITY"].stringValue
        Cost_Center.text = Vale["COSTCENTER"].stringValue
        Currency.text = Vale["CURRENCY"].stringValue
        
        RM_Satatus.text = Vale["rmStatus"].stringValue
        RM_Date.text = Vale["RMAPPDate"].stringValue
        RM_Remarks.text = Vale["rmRemarks"].stringValue
        
        Regional_Satatus.text = Vale["hodStatus"].stringValue
        Regional_Date.text = Vale["ReginalAppDate"].stringValue
        Regional_Remarks.text = Vale["hodRemarks"].stringValue
        
        
        Finance_Satatus.text = Vale["financeStatus"].stringValue
        Finance_Date.text = Vale["FinanceAppDate"].stringValue
        Finance_Remarks.text = Vale["financeRemarks"].stringValue
        
        
        
    }
    
}











class local_Details_Cell1:UITableViewCell
{

    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var expense_Type:UILabel!
    @IBOutlet weak var Mode:UILabel!
    @IBOutlet weak var PaidBY:UILabel!
    @IBOutlet weak var KM:UILabel!
    @IBOutlet weak var Eligibility:UILabel!
    @IBOutlet weak var Ammount:UILabel!
    @IBOutlet weak var Approve_Ammount:UITextField!
    @IBOutlet weak var Total_Ammount:UILabel!
    
}

class local_Details_Cell2:UITableViewCell
{
    @IBOutlet weak  var Date:UILabel!
    @IBOutlet weak  var ammount:UILabel!
    @IBOutlet weak  var expense_Type:UILabel!
    @IBOutlet weak  var particular:UILabel!
    @IBOutlet weak  var Approved_Ammount:UITextField!
    @IBOutlet weak  var total_Ammount:UILabel!
}
