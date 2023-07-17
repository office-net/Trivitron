//
//  ViewIndentVC.swift
//  HRMS Trivitron
//
//  Created by Netcommlabs on 14/07/23.
//

import UIKit
import SwiftyJSON
class ViewIndentVC: UIViewController {
    
    @IBOutlet weak var ClientName: UILabel!
    @IBOutlet weak var QuastationNumber: UILabel!
    @IBOutlet weak var selectDate: UILabel!
    @IBOutlet weak var Branch: UILabel!
    @IBOutlet weak var AddressSOldParty: UILabel!
    @IBOutlet weak var contactPersonName: UILabel!
    @IBOutlet weak var contactNumber: UILabel!
    @IBOutlet weak var refCommissionNUmber: UITextField!
    @IBOutlet weak var GSTnumber: UITextField!
    @IBOutlet weak var Chargable: UITextField!
    @IBOutlet weak var ProductNumber: UITextField!
    @IBOutlet weak var TypeOfservice: UITextField!
    @IBOutlet weak var SiteAddres: UILabel!
    @IBOutlet weak var contactPersonNumber: UITextField!
    @IBOutlet weak var YearManu: UITextField!
    var ReqId = ""
    var ServiceID = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quotation Requisition Details"
        APiViewIndent()
        
    }
    
}

extension ViewIndentVC
{
    func setValue(data:JSON)
    {
        ClientName.text = data["clientName"].stringValue
        QuastationNumber.text = data["quotationno"].stringValue
        selectDate.text = data["date"].stringValue
        Branch.text = data["Branch"].stringValue
        AddressSOldParty.text = data["address"].stringValue
        contactPersonName.text = data["cname"].stringValue
        contactNumber.text = data["contactno"].stringValue
        refCommissionNUmber.text = data["refsno"].stringValue
        Chargable.text = data["isChargable"].stringValue
        ProductNumber.text = data["door"].stringValue
        TypeOfservice.text = data["warranty"].stringValue
        SiteAddres.text = data["shipaddress"].stringValue
        contactPersonNumber.text = data["conno"].stringValue
        YearManu.text = data["year"].stringValue
        GSTnumber.text = data["gstno"].stringValue
    }
}









  extension ViewIndentVC
{
      
      
      func APiViewIndent()
      {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
          let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
          let parameters = [    "TokenNo": token!,
                                "UserId": UserID!,
                                "ReqId": ReqId,
                                "ServiceID": ServiceID  ] as [String : Any]
          
          Networkmanager.postRequest(vv: self.view, remainingUrl:"ViewBreakDownIndent", parameters: parameters) { (response,data) in
              let Status = response["Status"].intValue
              if Status == 1
              {
                  self.setValue(data: response)
              }
              else
              {
                  let Message = response["Message"].stringValue
                  self.showAlertWithAction(message: Message)
              }
          }
          
    
      }
  }
