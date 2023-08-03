//
//  TasKDetailsVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 11/07/22.
//

import UIKit
import SwiftyJSON
import RSSelectionMenu
import SemiModalViewController
import CoreLocation
import MapKit

class TasKDetailsVC: UIViewController {
    var getdata:JSON = []
    var ADDITIONAL_PERSON:JSON = []
    var simpleSelectedArray = [String]()
    var ActionArray = [String]()
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
    
    
    
    
    var Latitude = ""
    var Longitude = ""
    
    
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
        
        self.Latitude = getdata["Latitude"].stringValue
        self.Longitude = getdata["Longitude"].stringValue
        
        
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
    
    
    @IBAction func btn_Menu(_ sender: Any) {
        self.SetupMenu(Sender: sender as! UIButton)
        
        
    }
    
    
}








extension TasKDetailsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.HieghtTbl.constant = CGFloat(250*ADDITIONAL_PERSON.count)
        return ADDITIONAL_PERSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TaskDetailsCell", for: indexPath)as! TaskDetailsCell
        cell.Nameofperson.text = ADDITIONAL_PERSON[indexPath.row]["PersonName"].stringValue
        cell.MobileNumber.text = ADDITIONAL_PERSON[indexPath.row]["ContactNo"].stringValue
        cell.designation.text = ADDITIONAL_PERSON[indexPath.row]["DESIGNATION"].stringValue
        cell.Email.text = ADDITIONAL_PERSON[indexPath.row]["Email_Id"].stringValue
        cell.AlterNativeNumber.text = ADDITIONAL_PERSON[indexPath.row]["AlternateMobNo"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}

extension TasKDetailsVC
{
    func SetupMenu(Sender:UIButton)
    {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: ActionArray, cellType: .subTitle) { (cell, name, indexPath) in
            
            cell.textLabel?.text = name
            cell.tintColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
            cell.textLabel?.textColor = #colorLiteral(red: 0.04421768337, green: 0.5256456137, blue: 0.5384403467, alpha: 1)
          
        }
        selectionMenu.setSelectedItems(items: simpleSelectedArray) { [weak self] (text, index, selected, selectedList) in
        self?.simpleSelectedArray = selectedList
       let value = text
        
        switch value {
        case "Reschedule Meeting":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "ReshchwduleTaskVC")as! ReshchwduleTaskVC
            secondVC.getData = JSON(rawValue: (self?.getdata)!)!
            self?.navigationController?.pushViewController(secondVC, animated: true)
        
        case "Set ETA Info":
            self?.simpleSelectedArray = [String]()
            let options: [SemiModalOption : Any] = [
                SemiModalOption.pushParentBack: false
            ]
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "TaskPlannerETaVC") as! TaskPlannerETaVC
          
            pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
            pvc.TaskId = (self?.getdata["TaskId"].stringValue)!
            pvc.modalPresentationStyle = .overCurrentContext
            self?.presentSemiViewController(pvc, options: options, completion: {
                print("Completed!")
            }, dismissBlock: {
            })
            
            
        case "Edit Task Entry":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "EditTaskVC")as! EditTaskVC
            secondVC.getdata = JSON(rawValue: (self?.getdata)!)!
       
            self?.navigationController?.pushViewController(secondVC, animated: true)
            //
            
            
        case "Share a Meeting Invitation":
            self?.simpleSelectedArray = [String]()
            let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
            let secondVC = storyboard.instantiateViewController(withIdentifier: "ShareInvitationVC")as! ShareInvitationVC
            secondVC.TaskID = (self?.getdata["TaskId"].stringValue)!
       
            self?.navigationController?.pushViewController(secondVC, animated: true)
           //"Route Details"
        case "Route Details":
            self?.simpleSelectedArray = [String]()
            if self?.Longitude != "" && self?.Latitude != ""
            {
                self?.openLocationInAppleMaps(latitude: Double((self?.Latitude)!)!, longitude: Double((self?.Longitude)!)!)
            }
            else
            {
                   selectionMenu.dismiss(animated: true, completion: {
                     let anotherAlert = UIAlertController(title: "Trivitron", message: "No Location Found", preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                     anotherAlert.addAction(okAction)
                    self?.present(anotherAlert, animated: true, completion: nil)
                })
            }
            
        case "Fill CVR Report":
            
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ConcludeTaskVC")as! ConcludeTaskVC
            vc.backData = (self?.getdata)!
            self?.navigationController?.pushViewController(vc, animated: true)
           
        default:
            print("Unknown player")
            self?.simpleSelectedArray = [String]()
         }

    }
        selectionMenu.dismissAutomatically = true

        selectionMenu.show(style: .popover(sourceView: Sender as UIView, size: CGSize(width: 220, height: 250)), from: self)
    }
    
    
    func openLocationInAppleMaps(latitude: Double, longitude: Double) {
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Location Name"
        mapItem.openInMaps(launchOptions: options)
    }
    
}
