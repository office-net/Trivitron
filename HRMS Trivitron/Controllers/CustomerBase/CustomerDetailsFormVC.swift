//
//  CustomerDetailsFormVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 25/05/23.
//

import UIKit
import SwiftyJSON

class CustomerDetailsFormVC: UIViewController {
    
    @IBOutlet weak var txt_LeadStatus: UITextField!
    @IBOutlet weak var QuatationValue: UITextField!
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var hh: NSLayoutConstraint!
    
    @IBOutlet weak var customerCode: UITextField!
    @IBOutlet weak var allocateTo: UITextField!
    
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var contactPersonName: UITextField!
    @IBOutlet weak var contactPersonNumber: UITextField!
    @IBOutlet weak var conTactpersonEmailId: UITextField!
    @IBOutlet weak var AlterNateContactPersonName: UITextField!
    @IBOutlet weak var AlterNateContactPersonNumber: UITextField!
    @IBOutlet weak var AlterNateContactPersonEmailid: UITextField!
    @IBOutlet weak var customerWebSite: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var billingAddress: UITextField!
    @IBOutlet weak var shipingAddress: UITextField!
    @IBOutlet weak var trivitronInstallation: UITextField!
    @IBOutlet weak var bussinessUnit: UITextField!
    @IBOutlet weak var Department: UITextField!
    @IBOutlet weak var subDepartment: UITextField!
    @IBOutlet weak var status: UITextField!
    @IBOutlet weak var remarks: UITextField!
    
    @IBOutlet weak var Region: UITextField!
    @IBOutlet weak var btn_Save: Gradientbutton!
    
    var backLeadId = ""
    var AllocatedUid = ""
    
    var BackData:JSON = []
    
    var gradePicker: UIPickerView!
    
    var AllocatedEmp:JSON = []
    var AllocatedEmpId = ""
    
    var Statuslist:JSON = []
    var StatusId = ""
    
    
    var TrivitronInstallationList:JSON = []
    var TrivitronInstallationId = ""
    
    
    var BusinessUnitList:JSON = ""
    var BusinessUnitId = ""
    
    var DepartmentList:JSON = []
    var DepartmentId = ""
    
    var SubDepartmentList:JSON = []
    var SubDepartmentId = ""
    
    
   
    
    var isFrom = ""
    var ReqID = ""
    
    var CountryList:JSON = []
    var countryid = ""
    
    var StateProvinceList:JSON = []
     var StateID = ""
    
    var RegionList:JSON = []
    var RegionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customer Details Form"
    
        UiSetup()

    }
    
    @IBAction func btn_Save(_ sender: Any) {
            validation()
    }
    
    
}

extension CustomerDetailsFormVC:UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if allocateTo.isFirstResponder
        {
            return AllocatedEmp.count
        }
        else if trivitronInstallation.isFirstResponder
        {
            return TrivitronInstallationList.count
        }
        else if bussinessUnit.isFirstResponder
        {
            return BusinessUnitList.count
        }
        else if Department.isFirstResponder
        {
            return DepartmentList.count
        }
        else if subDepartment.isFirstResponder
        {
            return SubDepartmentList.count
        }
        else if country.isFirstResponder
        {
            return CountryList.count
        }
        else if state.isFirstResponder
        {
            return StateProvinceList.count
        }
        else if Region.isFirstResponder
        {
            return RegionList.count
        }
        else
        {
            return Statuslist.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if allocateTo.isFirstResponder
        {
            return AllocatedEmp[row]["Name"].stringValue
        }
        else if trivitronInstallation.isFirstResponder
        {
            return TrivitronInstallationList[row]["Name"].stringValue
        }
        else if bussinessUnit.isFirstResponder
        {
            return BusinessUnitList[row]["Name"].stringValue
        }
        else if Department.isFirstResponder
        {
            return DepartmentList[row]["Name"].stringValue
        }
        else if subDepartment.isFirstResponder
        {
            return SubDepartmentList[row]["Name"].stringValue
        }
        
        
        else if country.isFirstResponder
        {
            return CountryList[row]["Name"].stringValue
        }
        else if state.isFirstResponder
        {
            return StateProvinceList[row]["Name"].stringValue
        }
        else if Region.isFirstResponder
        {
            return RegionList[row]["Name"].stringValue
        }
        
        
        
        else
        {
            return Statuslist[row]["Name"].stringValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if allocateTo.isFirstResponder
        {
            allocateTo.text =  AllocatedEmp[row]["Name"].stringValue
            AllocatedEmpId =  AllocatedEmp[row]["Id"].stringValue
        }
        else if trivitronInstallation.isFirstResponder
        {
            trivitronInstallation.text =  TrivitronInstallationList[row]["Name"].stringValue
            TrivitronInstallationId =  TrivitronInstallationList[row]["Name"].stringValue
        }
        else if bussinessUnit.isFirstResponder
        {
            bussinessUnit.text =  BusinessUnitList[row]["Name"].stringValue
            BusinessUnitId =  BusinessUnitList[row]["Id"].stringValue
        }
        else if Department.isFirstResponder
        {
            Department.text =  DepartmentList[row]["Name"].stringValue
            DepartmentId =  DepartmentList[row]["Id"].stringValue
        }
        else if subDepartment.isFirstResponder
        {
            subDepartment.text =  SubDepartmentList[row]["Name"].stringValue
            SubDepartmentId =  SubDepartmentList[row]["Id"].stringValue
        }
        
        
        else if country.isFirstResponder
        {
            country.text =  CountryList[row]["Name"].stringValue
            countryid =  CountryList[row]["Id"].stringValue
        }
        else if state.isFirstResponder
        {
            state.text =  StateProvinceList[row]["Name"].stringValue
            StateID =  StateProvinceList[row]["Id"].stringValue
        }
        else if Region.isFirstResponder
        {
            Region.text =  RegionList[row]["Name"].stringValue
            RegionId =  RegionList[row]["Id"].stringValue
        }
        
        
        
        else
        {
            status.text =  Statuslist[row]["Name"].stringValue
            StatusId =  Statuslist[row]["Id"].stringValue
        }
    }
}




extension CustomerDetailsFormVC
{
    func UiSetup()
    {   ApiCallingMasterData()
        
        switch isFrom
        {
        case "Re-Clasify" :
            txt_LeadStatus.text = "Quotation Submitted"
            txt_LeadStatus.isUserInteractionEnabled = false
            customerName.text = BackData["UserViewLeadCustomerlst"][0]["PLEAD_NAME"].stringValue
            customerName.isUserInteractionEnabled = false
            contactPersonName.text = BackData["UserViewLeadCustomerlst"][0]["PCONTACT_PERSON_NAME"].stringValue
            contactPersonName.isUserInteractionEnabled = false
            contactPersonNumber.text = BackData["UserViewLeadCustomerlst"][0]["PCONTACT_NO"].stringValue
            contactPersonNumber.isUserInteractionEnabled = false
            conTactpersonEmailId.text = BackData["UserViewLeadCustomerlst"][0]["PEMAIL_ID"].stringValue
            conTactpersonEmailId.isUserInteractionEnabled = false
            country.text = BackData["UserViewLeadCustomerlst"][0]["COUNTRYID"].stringValue
            if country.text == ""
            {
                country.isUserInteractionEnabled = true
            }
            else
            {
                country.isUserInteractionEnabled = false
            }
        
            state.text = BackData["UserViewLeadCustomerlst"][0]["STATEID"].stringValue
            
            if state.text == ""
            {
                state.isUserInteractionEnabled = true
            }
            else
            {
                state.isUserInteractionEnabled = false
            }
         
            postalCode.text = BackData["UserViewLeadCustomerlst"][0]["PINOCDE"].stringValue
            postalCode.isUserInteractionEnabled = false
            
            
            
            
        case "View" :
            vv.isHidden = true
            hh.constant = 0
            btn_Save.isHidden = true
            ApiCallingViewDetails()
            self.title = "Customer Details"
         
        default :
         
            vv.isHidden = true
            hh.constant = 0
      
            
        }
     
        gradePicker = UIPickerView()
        self.allocateTo.inputView = gradePicker
        self.allocateTo.delegate = self
        self.status.inputView = gradePicker
        self.status.delegate = self
        
        self.trivitronInstallation.inputView = gradePicker
        self.trivitronInstallation.delegate = self
        
        self.bussinessUnit.inputView = gradePicker
        self.bussinessUnit.delegate = self
        
        self.Department.inputView = gradePicker
        self.Department.delegate = self
        
        self.subDepartment.inputView = gradePicker
        self.subDepartment.delegate = self
        
        self.country.inputView = gradePicker
        self.country.delegate = self
        self.state.inputView = gradePicker
        self.state.delegate = self
        self.Region.inputView = gradePicker
        self.Region.delegate = self
        
        
        
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        
        
        
    }
}




extension CustomerDetailsFormVC
{  func ApiSubmitDetails(IsCustomerBase:String,REQID:String,Region:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters = [String : Any]()
        parameters = ["IsCustomerBase":IsCustomerBase,"TokenNo":token!,"UserId":UserID!,"LeadStatusId":"4","Remarks":"","LeadId":backLeadId,"Quotation":QuatationValue.text ?? "","AppropriateValue":"","LostRemarks":"","CustomerCode":customerCode.text!,"AllocatedToEmpID":AllocatedUid,"CustomerName":customerName.text ?? "","ContactPersonName":contactPersonName.text ?? "","ContactPersonMobileNo":contactPersonNumber.text ?? "","ContactPersonEmailID":conTactpersonEmailId.text ?? "","AlternateContactPersonName":AlterNateContactPersonName.text ?? "","AlternateContactPersonMobileNo":AlterNateContactPersonNumber.text ?? "","AlternateContactPersonEmailID":AlterNateContactPersonEmailid.text ?? "","CustomerWebsite":customerWebSite.text ?? "","Country":countryid,"StateProvince":StateID,"City":city.text!,"PostalCode":postalCode.text!,"BillingAddress":billingAddress.text ?? "","ShippingAddress":shipingAddress.text ?? "","TrivitronInstallation":TrivitronInstallationId,"BusinessUnit":BusinessUnitId,"Department":DepartmentId,"SubDepartment":SubDepartmentId,"Status":StateID,"CusBaseRemarks":remarks.text ?? "","REQID":REQID,"Region":Region]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SaveReclassifySTS", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if Status == 1
            {
                
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
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
    
    func ApiCallingMasterData()
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!,"UserId": UserID!] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CustomerBaseSpinner", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                
                self.customerCode.text = response["CustomerCode"].stringValue
                
                self.allocateTo.text = response["AllocatedName"].stringValue
                self.AllocatedUid = response["AllocatedUid"].stringValue
                
                self.customerCode.isUserInteractionEnabled = false
                self.AllocatedEmp = response["AllocatedEmp"]
                self.DepartmentList = response["Department"]
                self.Statuslist = response["Statuslist"]
                self.TrivitronInstallationList = response["TrivitronInstallation"]
                self.BusinessUnitList = response["BusinessUnit"]
                self.SubDepartmentList = response["SubDepartment"]
                
                self.CountryList = response["Country"]
                self.StateProvinceList = response["StateProvince"]
                self.RegionList = response["Region"]
                
                
                
                
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
            }
            
            
            
        }
    }
    
    
    func ApiCallingViewDetails()
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo": token!,"UserId": UserID!,"ReqId":self.ReqID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CustomerBaseDetailByID", parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
                self.customerCode.text = response["CustomerCode"].stringValue
                
                self.customerName.text = response["CustomerName"].stringValue
                self.customerName.isUserInteractionEnabled = false
                
                self.contactPersonName.text = response["ContactPersonName"].stringValue
                self.contactPersonName.isUserInteractionEnabled = false
                
                self.contactPersonNumber.text = response["ContactPersonMobileNo"].stringValue
                self.contactPersonNumber.isUserInteractionEnabled = false
                
                self.conTactpersonEmailId.text = response["ContactPersonEmailID"].stringValue
                self.conTactpersonEmailId.isUserInteractionEnabled = false
                
                self.AlterNateContactPersonName.text = response["AlternateContactPersonName"].stringValue
                self.AlterNateContactPersonName.isUserInteractionEnabled = false
                
                self.AlterNateContactPersonNumber.text = response["AlternateContactPersonMobileNo"].stringValue
                self.AlterNateContactPersonNumber.isUserInteractionEnabled = false
                
                self.AlterNateContactPersonEmailid.text = response["AlternateContactPersonEmailID"].stringValue
                self.AlterNateContactPersonEmailid.isUserInteractionEnabled = false
                
                self.customerWebSite.text = response["CustomerWebsite"].stringValue
                self.customerWebSite.isUserInteractionEnabled = false
                
                self.country.text = response["Country"].stringValue
                self.country.isUserInteractionEnabled = false
                
                self.state.text = response["StateProvince"].stringValue
                self.state.isUserInteractionEnabled = false
                
                self.city.text = response["City"].stringValue
                self.city.isUserInteractionEnabled = false
                
                self.postalCode.text = response["PostalCode"].stringValue
                self.postalCode.isUserInteractionEnabled = false
                
                self.billingAddress.text = response["BillingAddress"].stringValue
                self.billingAddress.isUserInteractionEnabled = false
                
                self.shipingAddress.text = response["ShippingAddress"].stringValue
                self.shipingAddress.isUserInteractionEnabled = false
                
                self.trivitronInstallation.text = response["TrivitronInstallation"].stringValue
                self.trivitronInstallation.isUserInteractionEnabled = false
                
                self.bussinessUnit.text = response["BusinessUnit"].stringValue
                self.bussinessUnit.isUserInteractionEnabled = false
                
                self.Department.text = response["Department"].stringValue
                self.Department.isUserInteractionEnabled = false
                
                self.subDepartment.text = response["SubDepartment"].stringValue
                self.subDepartment.isUserInteractionEnabled = false
                
                self.status.text = response["CustomerStatus"].stringValue
                self.status.isUserInteractionEnabled = false
                
                self.remarks.text = response["Remarks"].stringValue
                self.remarks.isUserInteractionEnabled = false
                
                self.Region.text = response["Region"].stringValue
                self.Region.isUserInteractionEnabled = false
                
                
            }
            else
            {   let Message = response["Message"].stringValue
                self.showAlert(message: Message)
                
            }
       
        }
    }
    
    
}


extension CustomerDetailsFormVC
{
    func validation()
    {
        if customerWebSite.text == ""
        {
            self.showAlert(message: "Please Enter Customer Website")
        }
        else  if country.text == ""
        {
            self.showAlert(message: "Please Enter Country")
        }
        else  if state.text == ""
        {
            self.showAlert(message: "Please Enter State")
        }
        else  if city.text == ""
        {
            self.showAlert(message: "Please Enter City")
        }
        else  if postalCode.text == ""
        {
            self.showAlert(message: "Please Enter Postal Code")
        }
        else  if billingAddress.text == ""
        {
            self.showAlert(message: "Please Enter Billing Addresss")
        }
        else  if shipingAddress.text == ""
        {
            self.showAlert(message: "Please Enter Shipping Address")
        }
        else  if TrivitronInstallationId == ""
        {
            self.showAlert(message: "Please Enter Trivitron Instalation")
        }
        else  if BusinessUnitId == ""
        {
            self.showAlert(message: "Please Enter Business Unit")
        }
        else  if DepartmentId == ""
        {
            self.showAlert(message: "Please Enter Department")
        }
        else  if SubDepartmentId == ""
        {
            self.showAlert(message: "Please Enter Sub Department")
        }
        else  if StatusId == ""
        {
            self.showAlert(message: "Please Enter Status")
        }
        else  if remarks.text == ""
        {
            self.showAlert(message: "Please Enter Remarks")
        }
        else
        {
            
            if isFrom == "Re-Clasify"
            {
                ApiSubmitDetails(IsCustomerBase: "No", REQID: "0", Region: "0")
            }
            else
            {
                ApiSubmitDetails(IsCustomerBase: "Yes", REQID: "0", Region: RegionId)
            }
        
        }
            
    }
    
 
}
