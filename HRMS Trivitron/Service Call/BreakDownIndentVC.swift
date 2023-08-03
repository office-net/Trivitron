//  BreakDownIndentVC.swift
//  HRMS Trivitron
//  Created by Netcommlabs on 30/06/23.


import UIKit
import SwiftyJSON
import Alamofire

class BreakDownIndentVC: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var HieghtTbl: NSLayoutConstraint!
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var Ticket_Ref_No: UILabel!
    @IBOutlet weak var DAte: UILabel!
    @IBOutlet weak var Branch: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var ContactPerson: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var CommissionNumber: UITextField!
    @IBOutlet weak var gstNumbner: UITextField!
    @IBOutlet weak var ChargeABLE: UITextField!
    @IBOutlet weak var doorNumber: UITextField!
    @IBOutlet weak var typeOfservice: UITextField!
    @IBOutlet weak var SiteAddress: UILabel!
    @IBOutlet weak var contactPersonNumber: UITextField!
    @IBOutlet weak var Year_Of_Many: UITextField!
    
    
    @IBOutlet weak var doorsize: UITextField!
    @IBOutlet weak var Partnumber: UITextField!
    @IBOutlet weak var Make: UITextField!
    @IBOutlet weak var Model: UITextField!
    @IBOutlet weak var SapCode: UITextField!
    @IBOutlet weak var Quantity: UITextField!
    @IBOutlet weak var TypeOfservice2: UITextField!
    @IBOutlet weak var UOM: UITextField!
    
    @IBOutlet weak var Remarks: UITextField!
    var indentID = ""
    var ServiceTypeID2 = ""
    var UOMID = ""
    
    var ChargableArray = ["Yes","NO"]
    var idChargabel = ""
    var StaticSerciveTypeList = ["Service","Amc"]
    
    var UOMList:JSON = []
    var ServiceList:JSON = []
    var idServiceType = ""
    var gradePicker: UIPickerView!
    
    var MaterialData = [[String:String]]()
    
    
    var ServiceID = ""
    var ReqID = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DerailsAPiCalling()
        UIsetup()
        
    }
    
    
    @IBAction func btn_Save(_ sender: Any) {
        if typeOfservice.text == ""
        {
            self.showAlert(message: "Please Select Type Of Service")
        }
        else
        {
            self.APiSubmit()
        }
    }
    
    
    @IBAction func btn_AddMore(_ sender: UIButton)
    {
        AddMore()
    }
    
}









//"IndentId":data["IndentId"].stringValue,
//           "article":data["Article"].stringValue,
//           "Door":data["DoorSize"].stringValue,
//           "Make":data["Make"].stringValue,
//           "Material":data["Material"].stringValue,
//           "Model":data["Model"].stringValue,
//           "Qty":data["Qty"].stringValue,
//           "Remarks":data["Remarks"].stringValue,
//           "Sap":data["SAP"].stringValue,
//           "UomId":data["UomId"].stringValue,
//           "TypeId":data["TypeId"].stringValue]



extension BreakDownIndentVC
{
    func APiSubmit()
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
          let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        
        let jsonData = try! JSONSerialization.data(withJSONObject: MaterialData, options: [])
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!

    
        let parameters = ["TokenNo": token!,
                          "UserId": UserID!,
                          "ReqID": ReqID,
                          "ServiceID": ServiceID,
                          "Quotationno": Ticket_Ref_No.text ?? "",
                          "Refsno": CommissionNumber.text ?? "",
                          "IsChargeable": idChargabel,
                          "Gstno": gstNumbner.text ?? "",
                          "Door": doorsize.text ?? "",
                          "Warranty": idServiceType,
                          "Year": Year_Of_Many.text ?? "",
                          "Revno": doorNumber.text ?? "",
                          "BreakdownIndent":jsonString] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"BreakdownIndentSave", parameters: parameters) { (response,data) in
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
    

    
    func DerailsAPiCalling()
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["UserId":UserID!,"TokenNo": token!,"ReqId":self.ReqID,"ServiceID":self.ServiceID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"ViewBreakDownIndent", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {   self.AddViewDewtails(data: response)
                
                if response["BreakdownIndent"].isEmpty
                {
                    
                }
                else
                {
                    for i in 0...response["BreakdownIndent"].count - 1
                    {   let data = response["BreakdownIndent"][i]
                        
                        
                        let dic = ["IndentId":data["IndentId"].stringValue,
                                   "article":data["Article"].stringValue,
                                   "Door":data["DoorSize"].stringValue,
                                   "Make":data["Make"].stringValue,
                                   "Material":data["Material"].stringValue,
                                   "Model":data["Model"].stringValue,
                                   "Qty":data["Qty"].stringValue,
                                   "Remarks":data["Remarks"].stringValue,
                                   "Sap":data["SAP"].stringValue,
                                   "UomId":data["UomId"].stringValue,
                                   "TypeId":data["TypeId"].stringValue]
                        self.MaterialData.append(dic)
                        self.indentID = data["IndentId"].stringValue
                    }
                   
                    
                    self.tbl.reloadData()
                }
            }
            else
            {
                self.showAlert(message: "")
            }
            
        }
    }
}



extension BreakDownIndentVC
{
    func UIsetup()
    {
        tbl.register(UINib(nibName: "IndentCell", bundle: nil), forCellReuseIdentifier: "IndentCell")
        tbl.delegate = self
        tbl.dataSource = self
        self.title = "Fill Indent"
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        
        ChargeABLE.delegate = self
        ChargeABLE.inputView = gradePicker
        
        typeOfservice.delegate = self
        typeOfservice.inputView = gradePicker
        
        TypeOfservice2.delegate = self
        TypeOfservice2.inputView = gradePicker
        
        UOM.delegate = self
        UOM.inputView = gradePicker
     
    }
    func AddMore()
    {
        if doorsize.text == ""
        {
            self.showAlert(message: "Please Enter Door Size")
        }
        else if SapCode.text == ""
        {
            self.showAlert(message: "Please Enter SAP Code")
        }
    
        else if Quantity.text == ""
        {
            self.showAlert(message: "Please Enter Quantity")
        }
     
        else
        {
            let indentid = (Int(self.indentID) ?? 0) + 1
            
            let dic = ["IndentId":"\(indentid)","article":Partnumber.text ?? "","Door":doorsize.text ?? "","Make":Make.text ?? "","Material":"","Model":Model.text ?? "","Qty":Quantity.text ?? "","Remarks":Remarks.text ?? "","Sap":SapCode.text ?? "","UomId":UOMID,"TypeId":ServiceTypeID2]
            self.MaterialData.append(dic)
            tbl.reloadData()
            
            doorsize.text = ""
            SapCode.text = ""
            ServiceTypeID2 = ""
            Quantity.text = ""
            UOMID = ""
            
        }
        
        
        
    }
    
    func AddViewDewtails(data:JSON)
    {
        print("==================sssss=s=s=s=s=s=s=s==ss=s=s==s=s=ss==ss==s=ss==ss=s=s=\(data)")
        ClientName.text = data["clientName"].stringValue
        Ticket_Ref_No.text = data["quotationno"].stringValue
        DAte.text = data["date"].stringValue
        
        Branch.text = data["Branch"].stringValue
        Address.text = data["address"].stringValue
        ContactPerson.text = data["cname"].stringValue
        contactNumber.text = data["contactno"].stringValue
        CommissionNumber.text = data["refsno"].stringValue
        gstNumbner.text = data["gstno"].stringValue
        let ab = data["isChargable"].stringValue
        if ab == "1"
        {
            ChargeABLE.text = "Yes"
        }
        else
        {
            ChargeABLE.text = "No"
        }
       
        
        doorNumber.text = data["door"].stringValue
        SiteAddress.text = data["shipaddress"].stringValue
        contactPersonNumber.text = data["conno"].stringValue
        Year_Of_Many.text = data["year"].stringValue
        
    }
}


extension BreakDownIndentVC
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ChargeABLE.isFirstResponder
        {
            return ChargableArray.count
        }
        else if typeOfservice.isFirstResponder
        {
            return ServiceList.count
        }
        else if TypeOfservice2.isFirstResponder
        {
            return StaticSerciveTypeList.count
        }
        else
        {
            return UOMList.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ChargeABLE.isFirstResponder
        {
            return ChargableArray[row]
            
        }
        else if typeOfservice.isFirstResponder
        {
            return ServiceList[row]["Name"].stringValue
        }
        
        else if TypeOfservice2.isFirstResponder
        {
            return StaticSerciveTypeList[row]
        }
        else
        {
            return UOMList[row]["Name"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if ChargeABLE.isFirstResponder
        {
            ChargeABLE.text =  ChargableArray[row]
            if self.ChargeABLE.text == "Yes"
            {
                self.idChargabel = "true"
            }
            else
            {
                self.idChargabel = "false"
            }
        }
        
        else if typeOfservice.isFirstResponder
        {
            typeOfservice.text =  ServiceList[row]["Name"].stringValue
            idServiceType =  ServiceList["Id"].stringValue
            
            
        }
        else if TypeOfservice2.isFirstResponder
        {
            TypeOfservice2.text =  StaticSerciveTypeList[row]
            
        }
        
        else
        {
            UOM.text =  UOMList[row]["Name"].stringValue
            UOMID =  UOMList[row]["Id"].stringValue
        }
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        if textField ==  ChargeABLE
        {
            ChargeABLE.text =  ChargableArray[0]
            if self.ChargeABLE.text == "Yes"
            {
                self.idChargabel = "true"
            }
            else
            {
                self.idChargabel = "false"
            }
        }
        
        if textField ==  typeOfservice
        {
            typeOfservice.text =  ServiceList[0]["Name"].stringValue
            idServiceType =  ServiceList["Id"].stringValue
            
            
        }
        if textField == TypeOfservice2
        {
            TypeOfservice2.text =  StaticSerciveTypeList[0]
            
        }
        
        if textField == UOM
        {
            UOM.text =  UOMList[0]["Name"].stringValue
            UOMID =  UOMList[0]["Id"].stringValue
        }
        return true
        
        
    }
}

extension BreakDownIndentVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.HieghtTbl.constant = CGFloat(MaterialData.count * 430)
        return MaterialData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "IndentCell", for: indexPath) as! IndentCell
        let data = MaterialData[indexPath.row]
        
        cell.DoorSize.text = data["Door"]
        cell.ArticalNumber.text = data["article"]
        cell.Make.text = data["Make"]
        cell.Model.text = data["Model"]
        cell.sapCode.text = data["Sap"]
        cell.RequiredQTy.text = data["Qty"]
        let av = data["TypeId"]
       if av == "1"
        {cell.TypeOfservice.text = "Service" }
        else
        {
            cell.TypeOfservice.text = "AMC"
            
        }
        let uom = data["UomId"]
        for i in 0...UOMList.count - 1
        {
            if uom == UOMList[i]["Id"].stringValue
            {
                cell.UOM.text = UOMList[i]["Name"].stringValue
                break
            }
       
        }

        cell.Remarks.text = data["Remarks"]
        cell.btn_Remove.tag = indexPath.row
        cell.btn_Remove.addTarget(self, action: #selector(TblButton), for: .touchUpInside)
        return cell
    }
    @objc func TblButton(_sender:UIButton)
    {
        self.MaterialData.remove(at: _sender.tag)
        self.tbl.reloadData()
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    
}
