//
//  BreakDownViewDetailsVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 26/06/23.
//

import UIKit
import SwiftyJSON
class BreakDownViewDetailsVC: UIViewController {
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
    @IBOutlet weak var Product:UILabel!
    @IBOutlet weak var DoorType:UILabel!
    @IBOutlet weak var Model:UILabel!
    @IBOutlet weak var Ref_So_Number:UILabel!
    @IBOutlet weak var Discription_of_issue:UILabel!
    @IBOutlet weak var Remarks:UILabel!
    @IBOutlet weak var Type_of_service:UILabel!
    @IBOutlet weak var Chargeable_nonChargeable:UILabel!
    @IBOutlet weak var Door_number:UILabel!
    @IBOutlet weak var Installed_On:UILabel!
    @IBOutlet weak var Root_cause:UILabel!
    @IBOutlet weak var Corrective_action:UILabel!
    @IBOutlet weak var Reassign:UILabel!
    @IBOutlet weak var Contractor_wo_number:UILabel!
    @IBOutlet weak var Observation_work_done:UILabel!
    @IBOutlet weak var service_number:UILabel!
    @IBOutlet weak var service_report_number:UILabel!
    @IBOutlet weak var Spares:UILabel!
    @IBOutlet weak var Stage_Status:UILabel!
    @IBOutlet weak var Stage_Date:UILabel!
    @IBOutlet weak var Additional_Person:UILabel!
    @IBOutlet weak var Reassifned_date:UILabel!
    @IBOutlet weak var Action_Taken_Date:UILabel!
    @IBOutlet weak var Action_Taken_Time:UILabel!
    
    
    var PageServiceType = ""
    var ServiceID = ""
    var ReqID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        
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
        
    }
    

 

}

extension BreakDownViewDetailsVC
{
    func APiCalling(ReqID:String,ServiceID:String ,EndPoint:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = [    "TokenNo": token!,
                              "UserId": UserID!,
                              "ReqID": ReqID,
                              "ServiceID": ServiceID] as [String : Any]
        Networkmanager.postRequest(vv: self.view, remainingUrl:EndPoint, parameters: parameters) { (response,data) in
            let Status = response["Status"].intValue
            if Status == 1
            {
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
}


extension BreakDownViewDetailsVC
{
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
        Spares.text = Json["Spares"].stringValue
        Stage_Status.text = Json["StageNAME"].stringValue
        Stage_Date.text = Json["StageDate"].stringValue
        Additional_Person.text = Json["AdditionalpersonNAME"].stringValue
        Reassifned_date.text = Json["ActionDate"].stringValue
        Action_Taken_Date.text = Json["ActionDate"].stringValue
        Action_Taken_Time.text = Json["ActionTime"].stringValue
        
    }
}
