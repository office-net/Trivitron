//
//  BreakDownEditVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 27/06/23.
//

import UIKit
import SwiftyJSON

class BreakDownEditVC: UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var ticketnumber:UILabel!
    @IBOutlet weak var ticketType:UILabel!
    @IBOutlet weak var ModeOfCall:UILabel!
    @IBOutlet weak var CustomerType:UILabel!
    @IBOutlet weak var CustomerName:UILabel!
    @IBOutlet weak var ProjectName:UILabel!
    @IBOutlet weak var CustomerBilingAddress:UILabel!
    @IBOutlet weak var CustomerShipingAddress:UILabel!
    @IBOutlet weak var ticketDate:UILabel!
    @IBOutlet weak var TicketTime:UILabel!
    @IBOutlet weak var RefTicketNumber:UILabel!
    @IBOutlet weak var PersonName:UILabel!
    @IBOutlet weak var PersonNumber:UILabel!
    @IBOutlet weak var PersonEmail:UILabel!
    @IBOutlet weak var AdditionalContactPerson:UILabel!
    @IBOutlet weak var AdditionalContactPerson_Number:UILabel!
    @IBOutlet weak var Landline_no:UILabel!
    @IBOutlet weak var Department:UILabel!
    @IBOutlet weak var Desigination:UILabel!
    @IBOutlet weak var Industry_catagory:UILabel!
    @IBOutlet weak var Status:UILabel!
    @IBOutlet weak var Quantity:UILabel!
    @IBOutlet weak var Region_Branch:UILabel!
    @IBOutlet weak var Assigned_Emp:UILabel!
    @IBOutlet weak var Reassigned_Emp:UILabel!
    @IBOutlet weak var Priority:UILabel!
    
    
    @IBOutlet weak var Product:UITextField!
    @IBOutlet weak var DoorType:UITextField!
    @IBOutlet weak var Model:UITextField!
    @IBOutlet weak var Ref_So_Number:UITextField!
    @IBOutlet weak var Discription_of_issue:UITextField!
    @IBOutlet weak var Remarks:UITextField!
    @IBOutlet weak var Type_of_service:UITextField!
    @IBOutlet weak var Chargeable_nonChargeable:UITextField!
    @IBOutlet weak var Door_number:UITextField!
    @IBOutlet weak var Installed_On:UITextField!
    @IBOutlet weak var Root_cause:UITextField!
    @IBOutlet weak var Corrective_action:UITextField!
    @IBOutlet weak var Reassign:UITextField!
    @IBOutlet weak var Contractor_wo_number:UITextField!
    @IBOutlet weak var Observation_work_done:UITextField!
    @IBOutlet weak var service_number:UITextField!
    @IBOutlet weak var service_report_number:UITextField!
    
    
    @IBOutlet weak var SelectStageDate: UITextField!
    @IBOutlet weak var CallStage: UITextField!
    
    @IBOutlet weak var btn_Yes: UIButton!
    @IBOutlet weak var btn_No: UIButton!
    @IBOutlet weak var btn_Others: UIButton!
    @IBOutlet weak var btn_DealerSpares: UIButton!
    
    
    @IBOutlet weak var btn_FillOption: UIButton!
    @IBOutlet weak var btn_UploadFile: UIButton!
    @IBOutlet weak var btn_PleaseChooseFile: UIButton!
    
    
    @IBOutlet weak var view_Yes: UIView!
    @IBOutlet weak var h_Yes: NSLayoutConstraint!
    @IBOutlet weak var View_OtherDetails: UIView!
    @IBOutlet weak var H_Others: NSLayoutConstraint!
    @IBOutlet weak var ViewDealer: UIView!
    @IBOutlet weak var H_Dealer: NSLayoutConstraint!
    
    @IBOutlet weak var selectadditionalperson: UITextField!
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var tbl2: UITableView!
    @IBOutlet weak var hTbl1: NSLayoutConstraint!
    @IBOutlet weak var hTbl2: NSLayoutConstraint!
    
    @IBOutlet weak var scheduledFromDate: UITextField!
    @IBOutlet weak var scheduledToDate: UITextField!
    @IBOutlet weak var actuallyProductQty: UITextField!
    @IBOutlet weak var ScheduleView: UIView!
    @IBOutlet weak var HieghtSchedule: NSLayoutConstraint!
    
    @IBOutlet weak var ViewOTP: UIView!
    @IBOutlet weak var EnterOtp: UITextField!
    @IBOutlet weak var btn_SendOtp: UIButton!
    @IBOutlet weak var ResendOtp: UIButton!
    @IBOutlet weak var HieghtViewOTP: NSLayoutConstraint!
    
    var typeOfUser = "existing"
    
    var ServiceID = ""
    
    
    var ReqID = ""
    var DropDownData:JSON = []
    var gradePicker: UIPickerView!
    var ArrayCharge_or_Not = ["Yes","No"]
    
    var Id_Type_Of_Service = ""
    var Id_Chareeable = ""
    var Id_Reassign = ""
    var Id_AdditionalPerson = ""
    var Id_Call_Status = ""
    
    
    var ProductArray = [String]()
    var Product_Value = ""
    var Selected_Product_Array = [String]()
    
    var DoorTypeArray = [String]()
    var DoorType_Value = ""
    var Selected_DoorType_Array = [String]()
    
    var FillIndent = "False"
    
    
    var ServiceImageArray = [[String:Any]]()
    var ServiceDocumentArray = [[String:Any]]()
    
    var fileData = [Any]()
    var spareimage = UIImage()
    
    var PageServiceType = ""
    
    var Spares = "1"
    var SparesSheet = "1"
    
    
    var VeryFY_OTP = false
    var OTP_RequestID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("=====================================\(PageServiceType)")
        uisetup()
        
    }
    @objc func didTapTextField(_ sender: UITapGestureRecognizer) {
        ProductSetup()
    }
    
    @objc func didTapTextField2(_ sender: UITapGestureRecognizer) {
        DoorTypeSetup()
    }
    
    
    @IBAction func Add_Images(_ sender: Any) {
        self.getImage()
    }
    
    @IBAction func btn_AddDoc(_ sender: UIButton) {
        self.getDocuments()
    }
    
    
    @IBAction func btn_Yes(_ sender: Any) {
        self.BtnYes()
    }
    
    @IBAction func btn_No(_ sender: Any) {
        BttNo()
    }
    
    
    @IBAction func btn_Other(_ sender: Any) {
        bttOther()
    }
    
    @IBAction func btn_Delar(_ sender: Any) {
        Dealer()
    }
    
    
    @IBAction func btn_Indent_Or_UploadFile(_ sender: UIButton) {
        indent_orIploadFile(sender: sender)
    }
    
    @IBAction func btn_FillOption(_ sender: Any) {
        SparesSheet = "0"
        btn_FillOption.isSelected = true
        btn_UploadFile.isSelected = false
        btn_PleaseChooseFile.setTitle("  Click To Fill Indent Details", for: .normal)
    }
    
    @IBAction func btn_UploadFile(_ sender: Any) {
        SparesSheet = "1"
        btn_FillOption.isSelected = false
        btn_UploadFile.isSelected = true
        btn_PleaseChooseFile.setTitle("  Please Choose File", for: .normal)
    }
    
    
    @IBAction func btn_UpdateDetails(_ sender: Any) {
        
        Validation()
    }
    
    @IBAction func btn_SendOtp(_ sender: Any) {
        
        if btn_SendOtp.titleLabel?.text == "Send OTP"
        {
            self.ApiSendOTP(ACTION: "Insert")
        }
        else
        {
            if EnterOtp.text == ""
            {
                self.showAlert(message: "Please Enter Otp First")
            }
            else
            {
                self.ApiSendOTP(ACTION: "Select")
            }
        }
    }
    
    @IBAction func ReSendOtp(_ sender: Any) {
        self.ApiSendOTP(ACTION: "Insert")
    }
    
    
    
    
    
    
    func ApiSendOTP(ACTION:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var   parameters = [String : Any]()
        if ACTION == "Insert"
        {
            parameters =  [ "TokenNo":token!,
                            "UserId": UserID!,
                            "ACTION": ACTION,
                            "TICKETNO": ticketnumber.text ?? "",
                            "CallStatus": Id_Call_Status,
                            "ReAssign2": Id_Reassign,
                            "CUSTOMER_MOBILE": PersonNumber.text ?? "",
                            "CUSTOMER_EMAIL": PersonEmail.text ?? "",
                            "CUSTOMERNAME": CustomerName.text ?? ""] as [String : Any]
        }
        else
        {
            parameters = ["TokenNo":token!,"UserId":UserID!,"ACTION":ACTION,"TICKETNO":ticketnumber.text ?? "","CallStatus":Id_Call_Status,"OtpReqId":OTP_RequestID,"OTP":EnterOtp.text ?? ""]
        }
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"SendOTP", parameters: parameters) { (response,data) in
            print(response)
            
            let Status = response["Status"].intValue
            if Status == 1
            {
                if ACTION == "Insert"
                {
                    self.ResendOtp.isHidden = false
                    self.btn_SendOtp.setTitle("verify OTP", for: .normal)
                    self.OTP_RequestID = response["OtpReqId"].stringValue
                }
                else
                {
                    self.ViewOTP.isHidden = true
                    self.HieghtViewOTP.constant = 0
                    self.VeryFY_OTP = true
                }
                self.showAlert(message: response["Message"].stringValue)
            }
            else
            {
                if ACTION == "Insert"
                {
                    self.ResendOtp.isHidden = true
                    self.btn_SendOtp.setTitle("Send OTP", for: .normal)
                }
                else
                {   self.ViewOTP.isHidden = false
                    self.HieghtViewOTP.constant = 50
                    self.VeryFY_OTP = true
                }
                self.showAlert(message: response["Message"].stringValue)
            }
        }
        
    }
    
    
    
    
    func Validation()
    {
        if Product.text == ""
        {
            self.showAlert(message: "Please Product Segment Type")
        }
        else if DoorType.text == ""
        {
            self.showAlert(message: "Please Product Type")
        }
        else if Type_of_service.text == ""
        {
            self.showAlert(message: "Please Select Type Of Service")
        }
        else if Chargeable_nonChargeable.text == ""
        {
            self.showAlert(message: "Please Select Is Chargable/Not Chargable")
        }
        else if Reassign.text == ""
        {
            
            
            self.showAlert(message: "Please Select Reassign Employee")
        }
        
        else if CallStage.text == ""
        {
            self.showAlert(message: "Please Select Call Status")
        }
        else if HieghtViewOTP.constant == 50 && VeryFY_OTP == false
        {
            self.showAlert(message: "Please Verify OTP First. Otherwise change call Status Type")
        }
        else
        {
            switch self.PageServiceType
            {
            case "Installation":
                
                self.ApiUpdateDeails(EndPoint: "AmcUpdate.ashx")
            case "Breakdown":
                
                self.ApiUpdateDeails(EndPoint: "Breakdownupdate.ashx")
            case "Preventive Maintenance":
                
                self.ApiUpdateDeails(EndPoint: "Serviceupdate.ashx")
            case "Spares":
                
                self.ApiUpdateDeails(EndPoint: "Spareupdate.ashx")
            case "Application":
                
                self.ApiUpdateDeails(EndPoint: "ApplicationUpdate.ashx")
            case "Training":
                
                self.ApiUpdateDeails(EndPoint: "TrainingUpdate.ashx")
                
                
            default:
                self.ApiUpdateDeails(EndPoint: "OtherUpdate.ashx")
            }
            
            
        }
    }
    
    func ApiUpdateDeails(EndPoint:String)
    {
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var productId = ""
        for i in 0...DropDownData["ProductSubmit"].count - 1
        {
            if Product.text == DropDownData["ProductSubmit"][i]["Name"].stringValue
            {
                productId = DropDownData["ProductSubmit"][i]["Id"].stringValue
                break
            }
        }
        
        var DoorTypeId = ""
        for i in 0...DropDownData["DoorSubmit"].count - 1
        {
            if DoorType.text == DropDownData["DoorSubmit"][i]["Name"].stringValue
            {
                DoorTypeId = DropDownData["DoorSubmit"][i]["Id"].stringValue
                break
            }
        }
        
        var parameters = [
            "AddDetail": [
                "Type": typeOfUser,
                "TokenNo": token!,
                "UserId": UserID!,
                "ReqID": self.ReqID,
                "ServiceID": self.ServiceID,
                "ServiceType": Id_Type_Of_Service,
                "TicketNo": ticketnumber.text ?? "",
                "IsCharge": Id_Chareeable,
                "DoorNo": Door_number.text ?? "",
                "InstalledDate": Installed_On.text ?? "",
                "Root": Root_cause.text ?? "",
                "Correction": Corrective_action.text ?? "",
                "ReAssign2": Id_Reassign,
                "Additionalperson": Id_AdditionalPerson,
                "Contractor": Contractor_wo_number.text ?? "",
                "Observation": Observation_work_done.text ?? "",
                "ServiceNo": service_number.text ?? "",
                "ServiceReport": service_report_number.text ?? "",
                "StageStatus": Id_Call_Status,
                "StageDate": SelectStageDate.text ?? "",
                "Spares": self.Spares,
                "Product": productId,
                "SparesSheet": self.SparesSheet,
                "DoorType": DoorTypeId,
                "Model": Model.text ?? "",
                "RefSONo": Ref_So_Number.text ?? "",
                "Issues": Discription_of_issue.text ?? "",
                "Remarks": Remarks.text ?? "",
                "LocalConveyanceDetails": NSNull(),
                "ScheduleEndDate": scheduledToDate.text!,
                "ScheduleStartDate": scheduledFromDate.text!,
                "TotalPOSchedule": ""
            ] as [String : Any]
        ]

        if PageServiceType != "Installation" {
            parameters["AddDetail"]!["LocalConveyanceDetails"] = NSNull()
        }
        
        var serimgaray = [UIImage]()
        if self.ServiceImageArray.count != 0
        {
            for i in 0...self.ServiceImageArray.count - 1
            {
                serimgaray.append((ServiceImageArray[i]["Image"] as? UIImage)!)
            }
        }
        Networkmanager.postAndGetData2(EndPoint: EndPoint, vv: self.view, parameters: parameters, imgSpare:spareimage , imgServices: serimgaray, PdfData: self.fileData) { (response,data) in
            
            print(response)
            print(parameters)
            let status = response["Status"].intValue
            let msg = response["Message"].stringValue
            if status == 1
            {
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                self.showAlert(message: msg)
            }
            
            
            
        }
    }
    
    
}



extension BreakDownEditVC
{
    func APiCalling(ReqID:String,ServiceID:String,EndPoint:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = [    "TokenNo": token!,
                              "UserId": UserID!,
                              "ReqID": ReqID,
                              "ServiceID": ServiceID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:EndPoint, parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {   print(response)
                switch self.PageServiceType
                {
                    
                case "Installation":
                    
                    self.SetData(Json: response["AmcListById"][0])
                case "Breakdown":
                    
                    self.SetData(Json: response["BreakdownListById"][0])
                case "Preventive Maintenance":
                    
                    self.SetData(Json: response["ServiceListById"][0])
                case "Spares":
                    
                    self.SetData(Json: response["SpareListById"][0])
                case "Application":
                    
                    self.SetData(Json: response["ApplicationListById"][0])
                case "Training":
                    
                    self.SetData(Json: response["TrainingListById"][0])
                    
                    
                default:
                    self.SetData(Json: response["OtherListById"][0])
                }
                
                
                
                
            }
            else
            {
                let Message = response["Message"].stringValue
                let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                    
                }
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            }
            
            
            
        }
    }
    
    func APiCallingDropDown()
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token!,"UserId":UserID!,"ServiceID":self.ServiceID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"BindBreakdownDW", parameters: parameters) { (response,data) in
            let Status = response["status"].intValue
            //  print(response)
            if Status == 1
            {
                self.DropDownData = response
                if self.DropDownData["ProductSubmit"].count != 0
                {
                    for i in 0...response["ProductSubmit"].count - 1
                    {
                        self.ProductArray.append(response["ProductSubmit"][i]["Name"].stringValue)
                        
                    }
                    
                }
                
                if self.DropDownData["DoorSubmit"].count != 0
                {
                    for i in 0...self.DropDownData["DoorSubmit"].count - 1
                    {
                        self.DoorTypeArray.append(self.DropDownData["DoorSubmit"][i]["Name"].stringValue)
                        
                    }
                    
                }
                
            }
            else
            {
                let Message = response["Message"].stringValue
                self.showAlert(message: Message)
                
                
            }
            
            
            
        }
    }
    func SetData(Json:JSON)
    {
        ticketnumber.text = Json["TicketNo"].stringValue
        ticketType.text = Json["TicketType"].stringValue
        ModeOfCall.text = Json["ModeOfCallName"].stringValue
        CustomerType.text = Json["Customertype"].stringValue
        CustomerName.text = Json["CustomerName"].stringValue
        ProjectName.text = Json["ProjectName"].stringValue
        CustomerBilingAddress.text = Json["CBA"].stringValue
        CustomerShipingAddress.text = Json["CSA"].stringValue
        
        ticketDate.text = Json["TicketDate"].stringValue
        TicketTime.text = Json["Tickettime"].stringValue
        RefTicketNumber.text = Json["RefSDTicketNo"].stringValue
        PersonName.text = Json["Personname"].stringValue
        PersonNumber.text = Json["PesonNumber"].stringValue
        PersonEmail.text = Json["PersonEmail"].stringValue
        AdditionalContactPerson.text = Json["AdditonalContactPerson"].stringValue
        AdditionalContactPerson_Number.text = Json["AdditonalContactPersonNo"].stringValue
        Landline_no.text = Json["LandlineNumber"].stringValue
        Department.text = Json["Department"].stringValue
        Desigination.text = Json["Designation"].stringValue
        Industry_catagory.text = Json["IndustryCategoryName"].stringValue
        Status.text = Json["TicketStatus"].stringValue
        Quantity.text = Json["Qty"].stringValue
        Region_Branch.text = Json["Region_OR_BranchName"].stringValue
        Assigned_Emp.text = Json["AssignedEmpTO"].stringValue
        Reassigned_Emp.text = Json["ReAssignedEmpName"].stringValue
        Priority.text = Json["Priority"].stringValue
        
        Product.text = Json["ProductSubmit"].stringValue
        DoorType.text = Json["DoorName"].stringValue
        Model.text = Json["Model"].stringValue
        Ref_So_Number.text = Json["RefSONo"].stringValue
        Discription_of_issue.text = Json["Descriptionoftheissue"].stringValue
        Remarks.text = Json["Remarks"].stringValue
        Type_of_service.text = Json["SERVICETYPENAME"].stringValue
        Chargeable_nonChargeable.text = Json["ISCHARGETEXT"].stringValue
        Door_number.text = Json["DoorNo"].stringValue
        Installed_On.text = Json["InstalledDate"].stringValue
        
        Root_cause.text = Json["Root"].stringValue
        Corrective_action.text = Json["Correction"].stringValue
        Reassign.text = Json["ASSIGNEDUSERIDNAME"].stringValue
        Contractor_wo_number.text = Json["Contractor"].stringValue
        
        Observation_work_done.text = Json["Observation"].stringValue
        service_number.text = Json["Service"].stringValue
        service_report_number.text = Json["ServiceReport"].stringValue
        SelectStageDate.text = Json["StageDate"].stringValue
        
        
    }
    
}










extension BreakDownEditVC
{
    
    
    func uisetup()
    {
        
        
        gradePicker = UIPickerView()
        gradePicker.delegate = self
        gradePicker.dataSource = self
        
        Type_of_service.delegate = self
        Type_of_service.inputView =  gradePicker
        Chargeable_nonChargeable.delegate = self
        Chargeable_nonChargeable.inputView =  gradePicker
        Reassign.delegate = self
        Reassign.inputView =  gradePicker
        selectadditionalperson.delegate = self
        selectadditionalperson.inputView =  gradePicker
        CallStage.delegate = self
        CallStage.inputView =  gradePicker
        
        self.title = "Update Ticket Details"
        btn_No.isSelected = true
        view_Yes.isHidden = true
        h_Yes.constant = 0
        ViewDealer.isHidden = true
        H_Dealer.constant = 0
        View_OtherDetails.isHidden = true
        H_Others.constant = 0
        
        
        btn_UploadFile.isSelected = true
        
        HieghtViewOTP.constant = 0
        ViewOTP.isHidden = true
        ResendOtp.isHidden = true
        
        
        
        
        switch self.PageServiceType
        {
        case "Installation":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "AmcListById")
        case "Breakdown":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "BreakdownListById")
        case "Preventive Maintenance":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "ServiceListById")
        case "Spares":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "SpareListById")
        case "Application":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "ApplicationListById")
        case "Training":
            
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "TrainingListById")
            
            
        default:
            APiCalling(ReqID: self.ReqID, ServiceID: self.ServiceID, EndPoint: "OtherListById")
        }
        
        
        APiCallingDropDown()
        base.changeImageDropdown(textField: Product)
        base.changeImageDropdown(textField: DoorType)
        base.changeImageDropdown(textField: Type_of_service)
        base.changeImageDropdown(textField: Chargeable_nonChargeable)
        base.changeImageDropdown(textField: Reassign)
        base.changeImageDropdown(textField: selectadditionalperson)
        base.changeImageDropdown(textField: CallStage)
        base.changeImageCalender(textField: SelectStageDate)
        base.changeImageCalender(textField: Installed_On)
        
        base.changeImageCalender(textField: scheduledToDate)
        base.changeImageCalender(textField: scheduledFromDate)
        
        self.Installed_On.setInputViewDatePicker(target: self, selector: #selector(InstallDate))
        self.SelectStageDate.setInputViewDatePicker(target: self, selector: #selector(StageDate))
        let textFieldGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTextField))
        let textFieldGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapTextField2))
        Product.addGestureRecognizer(textFieldGestureRecognizer)
        DoorType.addGestureRecognizer(textFieldGestureRecognizer2)
        
        self.scheduledToDate.setInputViewDatePicker(target: self, selector: #selector(scheduleToDate))
        self.scheduledFromDate.setInputViewDatePicker(target: self, selector: #selector(scheduleFromDate))
        
        self.scheduledToDate.text = Date.getCurrentDate()
        self.scheduledFromDate.text = Date.getCurrentDate()
    }
    
    @objc func scheduleToDate() {
        if let datePicker = scheduledToDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            scheduledToDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        scheduledToDate.resignFirstResponder() // 2-5
    }
    
    @objc func scheduleFromDate() {
        if let datePicker = scheduledFromDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            scheduledFromDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        scheduledFromDate.resignFirstResponder() // 2-5
    }
    
}




//=================================Setup BUtton Functions ============================================================================






extension BreakDownEditVC

{
    func indent_orIploadFile(sender:UIButton)
    {
        print(FillIndent)
        if sender.titleLabel?.text == "  Click To Fill Indent Details"
        {
            if FillIndent == "True"
            {
                let storyboard = UIStoryboard(name: "ServiceCall", bundle: nil)
                let secondVC = storyboard.instantiateViewController(withIdentifier: "BreakDownIndentVC")as! BreakDownIndentVC
                secondVC.UOMList = DropDownData["UomList"]
                secondVC.ServiceList = DropDownData["Servicetype"]
                secondVC.ReqID = self.ReqID
                secondVC.ServiceID = self.ServiceID
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
            else
            {
                self.showAlert(message: "Please fill existing form First. Then Fill Indent Details")
            }
        }
        else
        {
            self.getImage()
        }
    }
    func Dealer()
    {
        Spares = "3"
        h_Yes.constant = 0
        
        btn_No.isSelected = false
        btn_Yes.isSelected = false
        btn_Others.isSelected = false
        btn_DealerSpares.isSelected = true
        
        H_Dealer.constant = 60
        H_Others.constant = 0
        
        view_Yes.isHidden = true
        ViewDealer.isHidden = false
        View_OtherDetails.isHidden = true
        
    }
    
    
    func bttOther()
    {
        Spares = "2"
        h_Yes.constant = 0
        
        btn_No.isSelected = false
        btn_Yes.isSelected = false
        btn_Others.isSelected = true
        btn_DealerSpares.isSelected = false
        
        H_Dealer.constant = 0
        H_Others.constant = 60
        
        view_Yes.isHidden = true
        ViewDealer.isHidden = true
        View_OtherDetails.isHidden = false
        
        
    }
    
    func BttNo()
    {  Spares = "1"
        
        btn_No.isSelected = true
        btn_Yes.isSelected = false
        btn_Others.isSelected = false
        btn_DealerSpares.isSelected = false
        
        
        view_Yes.isHidden = true
        h_Yes.constant = 0
        ViewDealer.isHidden = true
        H_Dealer.constant = 0
        View_OtherDetails.isHidden = true
        H_Others.constant = 0
        
    }
    
    func BtnYes()
    {   Spares = "0"
        h_Yes.constant = 90
        
        btn_No.isSelected = false
        btn_Yes.isSelected = true
        btn_Others.isSelected = false
        btn_DealerSpares.isSelected = false
        
        H_Dealer.constant = 0
        H_Others.constant = 0
        
        view_Yes.isHidden = false
        ViewDealer.isHidden = true
        View_OtherDetails.isHidden = true
        
    }
}





//=================================Setup PickerView============================================================================

extension BreakDownEditVC
{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if Type_of_service.isFirstResponder
        {
            return DropDownData["Servicetype"].count
        }
        else if Chargeable_nonChargeable.isFirstResponder
        {
            return ArrayCharge_or_Not.count
        }
        else if Reassign.isFirstResponder
        {
            return DropDownData["reassign2"].count
        }
        else if CallStage.isFirstResponder
        {
            return DropDownData["StageList"].count
        }
        else
        {
            return DropDownData["AssignedEmpName"].count
        }
        
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if Type_of_service.isFirstResponder
        {
            return DropDownData["Servicetype"][row]["Name"].stringValue
        }
        else if Chargeable_nonChargeable.isFirstResponder
        {
            return ArrayCharge_or_Not[row]
        }
        
        else if Reassign.isFirstResponder
        {
            return DropDownData["reassign2"][row]["Name"].stringValue
        }
        
        else if CallStage.isFirstResponder
        {
            return DropDownData["StageList"][row]["Name"].stringValue
        }
        else
        {
            return DropDownData["AssignedEmpName"][row]["Name"].stringValue
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if Type_of_service.isFirstResponder
        {
            Type_of_service.text =  DropDownData["Servicetype"][row]["Name"].stringValue
            Id_Type_Of_Service =  DropDownData["Servicetype"][row]["Id"].stringValue
        }
        else if Chargeable_nonChargeable.isFirstResponder
        {
            Chargeable_nonChargeable.text =  ArrayCharge_or_Not[row]
            if  Chargeable_nonChargeable.text == "Yes"
            {Id_Chareeable =  "0"}
            else
            {
                Id_Chareeable =  "0"
            }
            
            
            
        }
        else if Reassign.isFirstResponder
        {
            Reassign.text =  DropDownData["reassign2"][row]["Name"].stringValue
            Id_Reassign =   DropDownData["reassign2"][row]["Id"].stringValue
            
            
        }
        else if CallStage.isFirstResponder
        {
            CallStage.text =  DropDownData["StageList"][row]["Name"].stringValue
            Id_Call_Status =  DropDownData["StageList"][row]["Id"].stringValue
            if CallStage.text == "Fully Completed"
            {
                HieghtViewOTP.constant = 50
                self.ViewOTP.isHidden = false
            }
            else
            {
                HieghtViewOTP.constant = 0
                self.ViewOTP.isHidden = true
            }
            
        }
        
        else
        {
            selectadditionalperson.text =  DropDownData["AssignedEmpName"][row]["Name"].stringValue
            Id_AdditionalPerson =  DropDownData["AssignedEmpName"][row]["Id"].stringValue
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == Type_of_service
        {
            Type_of_service.text =  DropDownData["Servicetype"][0]["Name"].stringValue
            Id_Type_Of_Service =  DropDownData["Servicetype"][0]["Id"].stringValue
        }
        if textField == Chargeable_nonChargeable
        {
            Chargeable_nonChargeable.text =  ArrayCharge_or_Not[0]
            if  Chargeable_nonChargeable.text == "Yes"
            {Id_Chareeable =  "0"}
            else
            {
                Id_Chareeable =  "0"
            }
            
            
            
        }
        if textField == Reassign
        {
            Reassign.text =  DropDownData["reassign2"][0]["Name"].stringValue
            Id_Reassign =   DropDownData["reassign2"][0]["Id"].stringValue
            
            
        }
        else if  textField == CallStage
        {
            CallStage.text =  DropDownData["StageList"][0]["Name"].stringValue
            Id_Call_Status =  DropDownData["StageList"][0]["Id"].stringValue
            
            
        }
        
        else if  textField == selectadditionalperson
        {
            selectadditionalperson.text =  DropDownData["AssignedEmpName"][0]["Name"].stringValue
            Id_AdditionalPerson =  DropDownData["AssignedEmpName"][0]["Id"].stringValue
        }
        return true
    }
    
    
    
    @objc func InstallDate() {
        if let datePicker = self.Installed_On.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.Installed_On.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.Installed_On.resignFirstResponder() // 2-5
    }
    @objc func StageDate() {
        if let datePicker = self.SelectStageDate.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            
            dateformatter.dateFormat = "dd/MM/yyyy"
            
            //dateformatter.dateStyle = .medium // 2-3
            self.SelectStageDate.text = dateformatter.string(from: datePicker.date) //2-4
        }
        self.SelectStageDate.resignFirstResponder() // 2-5
    }
    
}







//=================================Setup for Select Product ============================================================================
import RSSelectionMenu
extension  BreakDownEditVC
{
    func ProductSetup()
    {
        Selected_Product_Array = [String]()
        
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: ProductArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
        }
        
        selectionMenu.setSelectedItems(items: Selected_Product_Array) { [weak self] (item, index, isSelected, selectedItems) in
            
            self?.Selected_Product_Array = selectedItems
            
            if selectedItems.count != 0
            {
                for i in 0...selectedItems.count - 1
                {
                    if i == 0
                    {
                        self?.Product_Value = selectedItems[i]
                    }
                    else
                    {
                        self?.Product_Value = self!.Product_Value + ",\(selectedItems[i])"
                    }
                    
                }
                self?.Product.text = self?.Product_Value
            }
            else
            {
                self?.Product_Value = ""
            }
            
        }
        selectionMenu.show(from: self)
    }
}




//=================================Setup for Select Door Type ============================================================================
extension  BreakDownEditVC
{
    func DoorTypeSetup()
    {
        Selected_DoorType_Array = [String]()
        
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: DoorTypeArray) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
        }
        
        selectionMenu.setSelectedItems(items: Selected_DoorType_Array) { [weak self] (item, index, isSelected, selectedItems) in
            
            self?.Selected_DoorType_Array = selectedItems
            
            if selectedItems.count != 0
            {
                for i in 0...selectedItems.count - 1
                {
                    if i == 0
                    {
                        self?.DoorType_Value = selectedItems[i]
                    }
                    else
                    {
                        self?.DoorType_Value = self!.DoorType_Value + ",\(selectedItems[i])"
                    }
                    
                }
                self?.DoorType.text = self?.DoorType_Value
            }
            else
            {
                self?.DoorType_Value = ""
            }
            
        }
        selectionMenu.show(from: self)
    }
}





extension BreakDownEditVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate
{  func getImage()
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Retrieve the selected image
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        let characters = "0123456789"
        let length = 4
        let randomString = String((0..<length).map{ _ in characters.randomElement()! })
        
        let dic = ["Image":selectedImage,"Name":"Image \(randomString)"] as [String : Any]
        self.ServiceImageArray.append(dic)
        self.tbl.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}







import SemiModalViewController

extension BreakDownEditVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl
        {    hTbl1.constant = CGFloat(ServiceImageArray.count * 70)
            return ServiceImageArray.count
        }
        else
        {
            hTbl2.constant = CGFloat(ServiceDocumentArray.count * 70)
            return ServiceDocumentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreakDownImageCell", for: indexPath)as! BreakDownImageCell
            cell.imgView.image = ServiceImageArray[indexPath.row]["Image"] as? UIImage
            cell.btn_Coose.setTitle("View Image", for: .normal)
            cell.btn_Coose.tag = indexPath.row
            cell.btn_Coose.addTarget(self, action: #selector(ImageViewButton(_sender:)), for: .touchUpInside)
            
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action: #selector(ImageViewButton_Delete(_Delete:)), for: .touchUpInside)
            
            return cell
        }
        
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocCell", for: indexPath)as! DocCell
            cell.img.image = UIImage(named: "pdf")
            cell.btnChoos.setTitle(ServiceDocumentArray[indexPath.row]["Name"] as? String, for: .normal)
            cell.Delete.tag = indexPath.row
            cell.Delete.addTarget(self, action: #selector(DeleteDocument(Doc_Delete:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func DeleteDocument(Doc_Delete:UIButton)
    {
        ServiceDocumentArray.remove(at: Doc_Delete.tag)
        self.fileData.remove(at: Doc_Delete.tag)
        self.tbl2.reloadData()
    }
    
    @objc func ImageViewButton_Delete(_Delete:UIButton)
    {
        ServiceImageArray.remove(at: _Delete.tag)
        self.tbl.reloadData()
    }
    @objc func ImageViewButton(_sender:UIButton)
    {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "ViewImageVC") as! ViewImageVC
        
        pvc.image = ServiceImageArray[_sender.tag]["Image"] as? UIImage
        pvc.Isfrom = true
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl
        {
            return 70
        }
        else
        {
            return 70
        }
    }
    
}



import MobileCoreServices
import Alamofire

extension BreakDownEditVC: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        //print("import result : \(myURL)")
        //let data = NSData(contentsOf: myURL)
        //print(myURL.lastPathComponent)
        
        
        // let fileData = try! Data(contentsOf: myURL)
        print("=========================\(myURL)")
        self.fileData.append(myURL)
        let dic = ["Name":myURL.lastPathComponent,"FileData":myURL] as [String : Any]
        self.ServiceDocumentArray.append(dic)
        self.tbl2.reloadData()
        
        
    }
    
    
    
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        
        print("view was cancelled")
        
        
    }
    
    
    func getDocuments()
    
    {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
}
