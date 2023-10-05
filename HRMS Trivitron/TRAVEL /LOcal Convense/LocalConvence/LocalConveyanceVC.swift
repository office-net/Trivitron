//
//  LocalConveyanceVC.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit
import SwiftyJSON

class LocalConveyanceVC: UIViewController {

    @IBOutlet weak var tbl: UITableView!
  @IBOutlet weak var seg: UISegmentedControl!
    
    
    
    
    var previousMonthStr = ""
    var nextMonthStr = ""
    var GetData:JSON = []
    var type = "Userview"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Local Conveyance"
        tbl.delegate = self
        tbl.dataSource =  self
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        let nextMonth = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: nextMonth!) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd/MM/yyyy"
        let strNextMonth = formatter.string(from: yourDate!)
        
        
        let myStringPrevious = formatter.string(from: PreviousMonth!) // string purpose I add here
        let yourDatePrevious = formatter.date(from: myStringPrevious)
        formatter.dateFormat = "dd/MM/yyyy"
        let strPreviousMonth = formatter.string(from: yourDatePrevious!)
        
        
        previousMonthStr = strPreviousMonth
        nextMonthStr = strNextMonth
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: self.type)
    }
 
    
    @IBAction func btn_NewForm(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalConveyanceFormVC")as! LocalConveyanceFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func Seg_Action(_ sender: Any) {
        if seg.selectedSegmentIndex == 0
        {

            
      
            self.type = "Userview"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Userview")
        }
        else if seg.selectedSegmentIndex == 1
        {
      
            self.type = "Pending"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Pending")
            
        }
        else
        {
    
            self.type = "Archived"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Archived")
        }
    }
    
}



extension LocalConveyanceVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "LocalConveyanceListCell", for: indexPath) as! LocalConveyanceListCell
        cell.Date.text = GetData[indexPath.row]["RequestDate"].stringValue
        cell.number.text = GetData[indexPath.row]["RequestNo"].stringValue
        cell.Traveller_Name.text = GetData[indexPath.row]["TravellerName"].stringValue
        cell.Status.text = GetData[indexPath.row]["FinalStatus"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Local", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "Local_Details")as! Local_Details
        secondVC.LCID = GetData[indexPath.row]["LCID"].stringValue
        secondVC.isFrom = self.type
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
}








extension LocalConveyanceVC
{
    func ComonApi(FromDate:String,toDate:String,RequestNumver:String,Type:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters:[String:Any]?
         parameters =    ["EmpCode":"","FromDate":FromDate,"RequestNo":RequestNumver,"ToDate":toDate,"TokenNo":token!,"Type":Type,"UserID":UserID!]
        Networkmanager.postRequestWithAlert(controller: self, vv: self.view, remainingUrl:"LCRequest_List" , parameters: parameters!) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {
                self.GetData = response["LCList"]
                self.tbl.isHidden = false
                self.tbl.reloadData()
            }
            else
            {
                
                self.tbl.isHidden = true
            }
         
    }
                                   
    }
}




class LocalConveyanceListCell:UITableViewCell
{
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var Traveller_Name: UILabel!
    @IBOutlet weak var Status: UILabel!
    
}
