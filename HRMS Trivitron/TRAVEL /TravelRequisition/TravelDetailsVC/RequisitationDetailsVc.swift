//
//  RequisitationDetailsVc.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 31/08/22.
//

import UIKit
import SwiftyJSON

class RequisitationDetailsVc: UIViewController {

    @IBOutlet weak var Hieght_Tbl2: NSLayoutConstraint!
    @IBOutlet weak var tblView2: UITableView!
    @IBOutlet weak var Hieght_Tbl1: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
 //====================Lable OutLet=======================
    @IBOutlet weak var empCode:UILabel!
    @IBOutlet weak var Name:UILabel!
    @IBOutlet weak var Department:UILabel!
    @IBOutlet weak var Location:UILabel!
    @IBOutlet weak var grade:UILabel!
    @IBOutlet weak var Division:UILabel!
    @IBOutlet weak var designation:UILabel!
    @IBOutlet weak var plant:UILabel!
    @IBOutlet weak var travellertType:UILabel!
    @IBOutlet weak var ticketBookedBy:UILabel!
    @IBOutlet weak var Fromdate:UILabel!
    @IBOutlet weak var ToDate:UILabel!
    @IBOutlet weak var PurposeOfTravel:UILabel!
    @IBOutlet weak var Remarks:UILabel!
    @IBOutlet weak var RmStatus:UILabel!
    @IBOutlet weak var RmRemarks:UILabel!
    @IBOutlet weak var HodStatus:UILabel!
    @IBOutlet weak var HodRemarks:UILabel!
    var trID = ""
    var TravelData:JSON = []
    var AccomodationData:JSON = []
    var TravelTicket:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "View Travel Requisitions Details"
        SetupTableView()
        apiCalling()
    }
    
    
    
    
    
}



extension RequisitationDetailsVc:UITableViewDataSource,UITableViewDelegate
{
    func SetupTableView()
    {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView2.delegate =  self
        self.tblView2.dataSource =  self
        self.tblView2.separatorStyle = .none
        self.tblView.separatorStyle = .none
        self.tblView.register(UINib(nibName: "CellRequisitationDetails", bundle: nil), forCellReuseIdentifier: "CellRequisitationDetails")
        self.tblView2.register(UINib(nibName: "CellAccomodatinDetails", bundle: nil), forCellReuseIdentifier: "CellAccomodatinDetails")
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblView{
            self.Hieght_Tbl1.constant = CGFloat((self.TravelData.count ) * 340)
        return  self.TravelData.count
        }
        
        else
        {
            self.Hieght_Tbl2.constant = CGFloat((self.AccomodationData.count) * 230)
            return AccomodationData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblView{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRequisitationDetails", for: indexPath) as! CellRequisitationDetails
        cell.lbl_DetailsNumber.text = "Requisition Detail : \(indexPath.row + 1)"
            cell.DepartureDate.text = TravelData[indexPath.row]["DepDate"].stringValue
            cell.DepartureTime.text = TravelData[indexPath.row]["DepTime"].stringValue
            cell.ArrivalDate.text = TravelData[indexPath.row]["ArrDate"].stringValue
            cell.ArrivalTime.text = TravelData[indexPath.row]["ArrTime"].stringValue
            cell.DepartureCountry.text = TravelData[indexPath.row]["FromCountry"].stringValue
            cell.DeparturePlace.text = TravelData[indexPath.row]["DepCity"].stringValue
            cell.DestinationCountry.text = TravelData[indexPath.row]["ToCountry"].stringValue
            cell.DestinationCity.text = TravelData[indexPath.row]["ArrCity"].stringValue
            cell.Mode.text = TravelData[indexPath.row]["Mode"].stringValue
            cell.Class.text = TravelData[indexPath.row]["Class"].stringValue
            cell.Name.text = "Name: "+TravelData[indexPath.row]["Name"].stringValue
            cell.Remarks.text = "Remarks: "+TravelData[indexPath.row]["Remark"].stringValue
            
        return  cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellAccomodatinDetails", for: indexPath) as! CellAccomodatinDetails
            cell.accomodationDetails.text = "Accomodation Details: \(indexPath.row + 1)"
            cell.Destinationplace.text = AccomodationData[indexPath.row]["Country"].stringValue
            cell.destinationCity.text = AccomodationData[indexPath.row]["DesCity"].stringValue
            cell.HotelName.text = AccomodationData[indexPath.row]["Hotel"].stringValue
            cell.CheckInDate.text = AccomodationData[indexPath.row]["CheckInDate"].stringValue
            cell.CheckoutDate.text = AccomodationData[indexPath.row]["CheckOutDate"].stringValue
            cell.CheckInTime.text = AccomodationData[indexPath.row]["CheckInTime"].stringValue
            cell.CheckOutTime.text = AccomodationData[indexPath.row]["CheckOutTime"].stringValue
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblView{
        return 340
        }
        else
        {
            return 230
        }
    }
    
    
}


extension RequisitationDetailsVc
{
    func apiCalling()
    {
        var parameters:[String:Any]?
     
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"1","TRID":self.trID]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"Request_Details", parameters: parameters!) { (response,data) in
            let json:JSON = response
            print(json)
            let status = json["Status"].intValue
            if status == 1
            {
                
                self.TravelData = json["TravelData"]
                self.TravelTicket =  json["TravelTicket"]
                self.AccomodationData = json["AccomodationData"]
                self.Name.text = json["emplyeeName"].stringValue
                self.empCode.text = json["empCode"].stringValue
                self.Department.text = json["department"].stringValue
                self.Location.text = json["location"].stringValue
                self.grade.text = json["grade"].stringValue
                self.Division.text = json["division"].stringValue
                self.designation.text = json["designation"].stringValue
                self.plant.text = json["plant"].stringValue
                
                self.travellertType.text = json["travellerType"].stringValue
              //  self.ticketBookedBy.text = json["plant"].stringValue
                self.Fromdate.text = json["tourFromDate"].stringValue
                self.ToDate.text = json["tourToDate"].stringValue
                
                self.RmStatus.text = "  "+json["rmStatus"].stringValue
                self.RmRemarks.text = "  "+json["rmRemarks"].stringValue
                self.HodStatus.text = "  "+json["hodStatus"].stringValue
                self.HodRemarks.text = "  "+json["hodRemarks"].stringValue
                self.PurposeOfTravel.text = "  "+json["travelPurpose"].stringValue
                self.Remarks.text = "  "+json["travelRemarks"].stringValue
                self.tblView.reloadData()
                self.tblView2.reloadData()
               
                
            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
            
        }
    }
}

