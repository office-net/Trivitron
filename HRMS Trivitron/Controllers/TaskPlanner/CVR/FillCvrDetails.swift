//
//  FillCvrDetails.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit
import SwiftyJSON
import CoreLocation

class FillCvrDetails: UIViewController {

    var dict = [String:Any]()
    
    var gradePicker: UIPickerView!
    @IBOutlet weak var btn_Submit: Gradientbutton!
    var delegate:FillCvr?
    var BackData:JSON = []
   
   
    var JsonProductofinterest:JSON = []
    var IDproductInterest = ""
    var Jsonproductofsegment:JSON = []
    var IdProductofsegment = ""
    var actionRequired:JSON = []
    var IDactionRequired = ""
  
    var reasonOfVisit:JSON = []
    var IDreasonOfVisir = ""
    var typeOfVisit:JSON = []
    var IDtypeVisit = ""
    var CUST_TYPE = ""
    var currentAddress = ""
    var locationManager:CLLocationManager!
    @IBOutlet weak var Desigination: UILabel!
    @IBOutlet weak var EmpCode: UILabel!
    @IBOutlet weak var EMpname: UILabel!
    @IBOutlet weak var  Branch: UILabel!
    @IBOutlet weak var CustomerName: UILabel!
    @IBOutlet weak var lbl_ContactMailID: UILabel!
    
    @IBOutlet weak var HieghtTbl: NSLayoutConstraint!
    @IBOutlet weak var txt_OutComeOfVisit: UITextField!
    @IBOutlet weak var txt_Location: UITextField!
    @IBOutlet weak var lbl_ContactNumber: UILabel!
    @IBOutlet weak var lbl_ContactPerson: UILabel!
    @IBOutlet weak var txt_State: CGFloatTextField!
    @IBOutlet weak var txt_CapitalCity: CGFloatTextField!
    @IBOutlet weak var txt_Remarks: UITextField!
    @IBOutlet weak var txt_TypeOfVisit: UITextField!
    @IBOutlet weak var txt_VisitResion: UITextField!
    @IBOutlet weak var txt_ActionRequired: UITextField!
    @IBOutlet weak var txt_TimeOfVisit: UITextField!
    
    
    @IBOutlet weak var tbl: UITableView!
    
    @IBOutlet weak var productSegment: UITextField!
    @IBOutlet weak var productOfIntrest: UITextField!
    @IBOutlet weak var unit: UITextField!
    
    @IBOutlet weak var customerType: UITextField!
    
    
    @IBOutlet weak var endtime: CGFloatTextField!
    
    @IBOutlet weak var startTime: CGFloatTextField!
    
    @IBOutlet weak var startDate: CGFloatTextField!
    @IBOutlet weak var endDate: CGFloatTextField!
    
    
    
    var ProductDetailsDish = [[String:Any]]()
    var ListCustomerTypeData = [["Id":"1076","Name":"Government"],["Id":"1082","Name":"Original Equipment Manufacturer"],["Id":"1075","Name":"Private"],["Id":"1080","Name":"Service Dealer"],["Id":"1081","Name":"Supply Dealer"],["Id":"1077","Name":"Tender-Government"],["Id":"1078","Name":"Tender-Private"]]
    
    
    var IdcustomerType = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Fill CVR Details"
        let taskID = BackData["TaskId"].stringValue
        
        self.ApiCallingForBindData(TaskId: taskID)
        ApiCallingProductDetails(TaskId: taskID, Productid: "0")
        UIsetup()
        print(BackData)
       
    }
    
    
    
  
    
    @IBAction func btn_Add(_ sender: Any) {
        if productSegment.text == ""
        {
            self.showAlert(message: "Please select Product segment")
        }
        else if productOfIntrest.text == ""
        {
            self.showAlert(message: "Please select Product Interest")
        }
        else if unit.text == ""
        {
            self.showAlert(message: "Please Enter Unit")
        }
        else
        {
            let dic = ["INTERESTID": IDproductInterest,
                       "productInterestName":  productOfIntrest.text!,
                       "SEGEMENTID": IdProductofsegment,
                       "productSegmentName":productSegment.text! ,
                       "NOOFUNIT": unit.text!]
            self.ProductDetailsDish.append(dic)
            self.tbl.reloadData()
            
            productOfIntrest.text = ""
            productSegment.text = ""
            unit.text = ""
        }
        
    }
    
    
 
    

    @IBAction func btn_Submit(_ sender: Any) {
        submitData()
   
    }
    

}




extension FillCvrDetails
{
    
    func submitData()
    {
        if txt_State.text == ""
        {
            self.showAlert(message: "Please Enter State Name")
        }
        else if txt_CapitalCity.text == ""
        {
            self.showAlert(message: "Please Enter City Name")
        }
        else if txt_Location.text == ""
        {
            self.showAlert(message: "Please Enter Location")
        }
        else if txt_TypeOfVisit.text == ""
        {
            self.showAlert(message: "Please  -- Select Type Of Visit --")
        }

        else if txt_VisitResion.text == ""
        {
            self.showAlert(message: " -- Select Reason of Visit --")
        }
        else if txt_OutComeOfVisit.text == ""
        {
            self.showAlert(message: "Please Enter Outcome Of Visit")
        }
        else if txt_ActionRequired.text == ""
        {
            self.showAlert(message: " -- Select action required --")
        }
        else if txt_Remarks.text == ""
        {
            self.showAlert(message: "Please Enter Remarks")
        }
        else
        {
            self.dict = [
                "AddProductDetail": ProductDetailsDish,
                "ACTION_REQ": IDactionRequired,
                "BRANCH": Branch.text ?? "",
                "CATE_OF_INTEREST": "0",
                "CITY_NAME": txt_CapitalCity.text ?? "",
                "CLIENT_INFORMATION": "0",
                "CONTACT_NO": lbl_ContactNumber.text ?? "",
                "CUSTOMER_NAME": CustomerName.text ?? "",
                "CUSTOMER_TYPE": IdcustomerType,
                "DATE_OF_VISIT": "",
                "DESIGNATION": Desigination.text ?? "",
                "EMAIL_ID": lbl_ContactMailID.text ?? "",
                "EMP_CODE": EmpCode.text ?? "",
                "EMP_NAME": EMpname.text ?? "",
                "LOCATION": txt_Location.text ?? "",
                "OtherProduct": "",
                "Reasonofotherremark": "",
                "OUTCOME_OF_VISIT": txt_OutComeOfVisit.text ?? "",
                "PERSON_NAME": lbl_ContactPerson.text ?? "",
                "REASON_OF_VISIT": IDreasonOfVisir,
                "REMARKS": txt_Remarks.text ?? "",
                "STATE_NAME": txt_State.text ?? "",
                "TIME_OF_VISIT": txt_TimeOfVisit.text ?? "",
                "TYPE_OF_VISIT": IDtypeVisit
            ] as [String : Any]
            delegate?.Action(CvrData: dict)
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}



extension FillCvrDetails:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HieghtTbl.constant = CGFloat(ProductDetailsDish.count * 250)
        return ProductDetailsDish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cvrCell", for: indexPath)as! cvrCell
        cell.pIntrest.text = ProductDetailsDish[indexPath.row]["productInterestName"] as? String
        cell.pSegment.text = ProductDetailsDish[indexPath.row]["productSegmentName"] as? String
        cell.unit.text = ProductDetailsDish[indexPath.row]["NOOFUNIT"] as? String
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(cvrCellButton), for: .touchUpInside)
        return cell
    }
    
    
    @objc func cvrCellButton(_sender:UIButton)
    {
        self.ProductDetailsDish.remove(at: _sender.tag)
        self.tbl.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
    }
    
}
















extension FillCvrDetails
{
    func ApiCallingForBindData(TaskId:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskId] as [String : Any]
                          
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CVRDataBindList", parameters: parameters) { (response,data) in
            let json:JSON = response
            //print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.actionRequired = json["actionRequired"]
              
             
    
                self.reasonOfVisit = json["reasonOfVisit"]
                self.typeOfVisit = json["typeOfVisit"]
                
                self.txt_CapitalCity.text = json["CityName"].stringValue
                self.txt_State.text = json["StateName"].stringValue
                if self.txt_CapitalCity.text == ""
                {
                    self.txt_CapitalCity.isUserInteractionEnabled = true
                }
                else
                {
                    self.txt_CapitalCity.isUserInteractionEnabled = false
                }
                if self.txt_State.text == ""
                {
                    self.txt_State.isUserInteractionEnabled = true
                }
                else
                {
                    self.txt_State.isUserInteractionEnabled = false
                }
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    func ApiCallingProductDetails(TaskId:String,Productid:String)
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0,"TaskId":TaskId,"Productid":Productid] as [String : Any]
                          
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SpinnerCRVentry", parameters: parameters) { (response,data) in
            let json:JSON = response
            //print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                self.Jsonproductofsegment = json["Productlist"]
                self.JsonProductofinterest = json["ProductInterest"]
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
    
    
}

extension FillCvrDetails: UIPickerViewDelegate, UIPickerViewDataSource ,UITextFieldDelegate
{

    
    func UIsetup()
    {
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        self.Branch.text = "HO"
        self.CUST_TYPE = BackData["CUST_TYPE"].stringValue
        
        self.currentAddress = BackData["CUSTOMER_LOCATION"].stringValue
        if currentAddress == ""
        {
            txt_Location.isUserInteractionEnabled  = true
        }
        else
        {
            txt_Location.text = currentAddress
            txt_Location.isUserInteractionEnabled  = false
        }
        self.CustomerName.text = BackData["CUSTOMER_NAME"].stringValue
        self.lbl_ContactPerson.text = BackData["ContactPerson"].stringValue
        self.lbl_ContactNumber.text = BackData["CONTACT_NO"].stringValue
        self.lbl_ContactMailID.text = BackData["EMAIL_ID"].stringValue
        
        self.startDate.text = BackData["STARTS_DATE"].stringValue
        self.startTime.text = BackData["START_TIME"].stringValue
        self.endDate.text = BackData["END_DATE"].stringValue
        self.endtime.text = BackData["END_TIME"].stringValue
        
        
        
        
        
        
        self.txt_TypeOfVisit.delegate = self
        self.txt_TypeOfVisit.inputView = gradePicker
  
        self.txt_VisitResion.delegate = self
        self.txt_VisitResion.inputView = gradePicker
        self.txt_ActionRequired.delegate = self
        self.txt_ActionRequired.inputView = gradePicker
        
        self.productSegment.delegate = self
        self.productSegment.inputView = gradePicker
        
        self.productOfIntrest.delegate = self
        self.productOfIntrest.inputView = gradePicker
   
        self.customerType.delegate = self
        self.customerType.inputView = gradePicker
        
        self.txt_TimeOfVisit.setInputViewDateTimePicker(target: self, selector: #selector(tapDoneStartTime))
        
     
        base.changeImageClock(textField: self.txt_TimeOfVisit)
        let UserName  = UserDefaults.standard.object(forKey: "UserName") as? String
        self.EMpname.text = UserName
        let EmpCode  = UserDefaults.standard.object(forKey: "EmpCode") as? String
        self.EmpCode.text = EmpCode
        let Desigination  = UserDefaults.standard.object(forKey: "Designation") as? String
        self.Desigination.text = Desigination
        
        
        

        
        
        
        
        
    }

    @objc func tapDoneStartTime() {
        if let datePicker = self.txt_TimeOfVisit.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "HH:mm:ss"
            
            self.txt_TimeOfVisit.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.txt_TimeOfVisit.resignFirstResponder() // 2-5
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txt_TypeOfVisit.isFirstResponder
        {
            return self.typeOfVisit.count
        }
     
        else if txt_VisitResion.isFirstResponder
        {
            return self.reasonOfVisit.count
        }
        else if productSegment.isFirstResponder
        {
            return self.Jsonproductofsegment.count
        }
        else if productOfIntrest.isFirstResponder
        {
            return self.JsonProductofinterest.count
        }
        else if customerType.isFirstResponder
        {
            return self.ListCustomerTypeData.count
        }
       
        else
        {
            return self.actionRequired.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if txt_TypeOfVisit.isFirstResponder
        {
            return self.typeOfVisit[row]["Name"].stringValue
        }
   
        else if txt_VisitResion.isFirstResponder
        {
            return self.reasonOfVisit[row]["Name"].stringValue
        }
        
        else if productSegment.isFirstResponder
        {
            return self.Jsonproductofsegment[row]["Name"].stringValue
        }
        
        else if productOfIntrest.isFirstResponder
        {
            return self.JsonProductofinterest[row]["Name"].stringValue
        }
        
        else if customerType.isFirstResponder
        {
            return self.ListCustomerTypeData[row]["Name"]
        }
     
        else
        {
            return self.actionRequired[row]["Name"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if txt_TypeOfVisit.isFirstResponder
        {
            txt_TypeOfVisit.text =  self.typeOfVisit[row]["Name"].stringValue
            IDtypeVisit = self.typeOfVisit[row]["ID"].stringValue
        }
   
        else if txt_VisitResion.isFirstResponder
        {
            txt_VisitResion.text =  self.reasonOfVisit[row]["Name"].stringValue
            IDreasonOfVisir = self.typeOfVisit[row]["ID"].stringValue
        }
        
        
        
        else if productSegment.isFirstResponder
        {
            productSegment.text =  self.Jsonproductofsegment[row]["Name"].stringValue
            IdProductofsegment = self.Jsonproductofsegment[row]["Id"].stringValue
            
            self.ApiCallingProductDetails(TaskId: BackData["TaskId"].stringValue, Productid: IdProductofsegment)
            productOfIntrest.text = ""
        }
        
        else if productOfIntrest.isFirstResponder
        {
            productOfIntrest.text =  self.JsonProductofinterest[row]["Name"].stringValue
            IDproductInterest = self.JsonProductofinterest[row]["Id"].stringValue
        }
        
        else if customerType.isFirstResponder
        {
            customerType.text =  self.ListCustomerTypeData[row]["Name"]
            IdcustomerType = self.ListCustomerTypeData[row]["Id"]!
        }
        
        else
        {
            txt_ActionRequired.text =  self.actionRequired[row]["Name"].stringValue
            IDactionRequired = self.typeOfVisit[row]["ID"].stringValue
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == productSegment
        {
            productSegment.text =  self.Jsonproductofsegment[0]["Name"].stringValue
            IdProductofsegment = self.Jsonproductofsegment[0]["Id"].stringValue
            
            self.ApiCallingProductDetails(TaskId: BackData["TaskId"].stringValue, Productid: IdProductofsegment)
            productOfIntrest.text = ""
            
        }
        if textField == productOfIntrest
        {
            productOfIntrest.text =  self.JsonProductofinterest[0]["Name"].stringValue
            IDproductInterest = self.JsonProductofinterest[0]["Id"].stringValue
        }
        
        if textField == txt_TypeOfVisit
        {
            txt_TypeOfVisit.text =  self.typeOfVisit[0]["Name"].stringValue
            IDtypeVisit = self.typeOfVisit[0]["ID"].stringValue
        }
        
        
        if textField == txt_VisitResion
        {
            txt_VisitResion.text =  self.reasonOfVisit[0]["Name"].stringValue
            IDreasonOfVisir = self.typeOfVisit[0]["ID"].stringValue
        }
        
        if textField == txt_ActionRequired
        {
            txt_ActionRequired.text =  self.actionRequired[0]["Name"].stringValue
            IDactionRequired = self.typeOfVisit[0]["ID"].stringValue
        }
        if textField == customerType
        {
            customerType.text =  self.ListCustomerTypeData[0]["Name"]
            IdcustomerType = self.ListCustomerTypeData[0]["Id"]!
        }
        
        
        
        
        
     return true
    }
}













class cvrCell:UITableViewCell
{
    @IBOutlet weak var btn_Delete: UIButton!
    
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var pIntrest: UITextField!
    @IBOutlet weak var pSegment: UITextField!
}
