//
//  TasKDetailsVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 11/07/22.
//

import UIKit
import SwiftyJSON

class TasKDetailsVC: UIViewController {
    var getdata:JSON = []
    var ADDITIONAL_PERSON:JSON = []
    
    @IBOutlet weak var tbl:UITableView!
    @IBOutlet weak var HieghtTbl:NSLayoutConstraint!
    
 
    @IBOutlet weak var Remarks: UILabel!
    @IBOutlet weak var CreatedDate: UILabel!
    @IBOutlet weak var CreatedBy: UILabel!
    @IBOutlet weak var SalesOffice: UILabel!
    @IBOutlet weak var MeetingType: UILabel!
    @IBOutlet weak var MeetingStatus: UILabel!
    @IBOutlet weak var TaskActivity: UILabel!
    @IBOutlet weak var VisitMarkTime: UILabel!
    @IBOutlet weak var VisitMarkLocation: UILabel!
    @IBOutlet weak var DepartureTime: UILabel!
    @IBOutlet weak var DepartureLocation: UILabel!
    @IBOutlet weak var CustomerLocation: UILabel!
    @IBOutlet weak var LblDateAndTimeOfMeeting: UILabel!
    @IBOutlet weak var lbl_contactPersonEmail: UILabel!
    @IBOutlet weak var lbl_contactPersonNumber: UILabel!
    @IBOutlet weak var lbl_contactPersonName: UILabel!
    @IBOutlet weak var lbl_CustomerName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task Details"
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UINib(nibName: "TaskDetailsCell", bundle: nil), forCellReuseIdentifier: "TaskDetailsCell")
        print(self.getdata)
        self.lbl_CustomerName.text = getdata["CUSTOMER_NAME"].stringValue
        self.lbl_contactPersonName.text = getdata["ContactPerson"].stringValue
        self.lbl_contactPersonEmail.text = getdata["EMAIL_ID"].stringValue
        self.lbl_contactPersonNumber.text = getdata["CONTACT_NO"].stringValue
        self.CustomerLocation.text = getdata["CUSTOMER_LOCATION"].stringValue
        self.DepartureLocation.text =  getdata["OgAddresss"].stringValue
        self.DepartureTime.text = getdata["OgOutGoingTime"].stringValue
        self.VisitMarkLocation.text = getdata["MarkLocation"].stringValue
        self.VisitMarkTime.text =  getdata["travelTime"].stringValue
        self.TaskActivity.text =  getdata["TASK_ACTIVITY"].stringValue
        self.MeetingStatus.text = getdata["MEETING_STATUS"].stringValue
        self.MeetingType.text = getdata["MeetingType"].stringValue
        self.SalesOffice.text = getdata["SalesOfficeName"].stringValue
        self.CreatedBy.text =  getdata["CreatedBy"].stringValue
        self.CreatedDate.text = getdata["CreatedDate"].stringValue
        self.Remarks.text = getdata["REMARKS"].stringValue
      
      
        let dateString = getdata["START_TIME"].stringValue
        let dateString2 = getdata["END_TIME"].stringValue
        print(dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        let date2 = dateFormatter.date(from: dateString2)
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

       LblDateAndTimeOfMeeting.text = "\(getdata["STARTS_DATE"].stringValue) \(dateString) To \(getdata["END_DATE"].stringValue) \(dateString2)"

    }
    



}



extension TasKDetailsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.HieghtTbl.constant = CGFloat(185*ADDITIONAL_PERSON.count)
        return ADDITIONAL_PERSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TaskDetailsCell", for: indexPath)as! TaskDetailsCell
        cell.Nameofperson.text = ADDITIONAL_PERSON[indexPath.row]["PersonName"].stringValue
        cell.MobileNumber.text = ADDITIONAL_PERSON[indexPath.row]["ContactNo"].stringValue
        cell.designation.text = ADDITIONAL_PERSON[indexPath.row]["DESIGNATION"].stringValue
        cell.Email.text = ADDITIONAL_PERSON[indexPath.row]["Email_Id"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    
}
