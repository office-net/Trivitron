//
//  TravelRequisitionVC.swift
//  OfficeNetTMS
//
//  Created by Netcommlabs on 23/08/22.
//

import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON

class TravelRequisitionVC: UIViewController {
    var GetData:JSON = []
    var previousMonthStr = ""
    var nextMonthStr = ""
    var count = 0
    var method = "Requisition_List"
    var type = "Userview"
  
    
    
    @IBOutlet weak var Lable_Data_Found: UILabel!
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    @IBAction func segMent(_ sender: Any) {
        if seg.selectedSegmentIndex == 0
        {

            
            self.method = "Requisition_List"
            self.type = "Userview"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "", Method: self.method)
        }
        else if seg.selectedSegmentIndex == 1
        {
            self.method = "Requisition_List"
            self.type = "Pending"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Pending", Method: self.method)
            
        }
        else
        {
            self.method = "Requisition_List"
            self.type = "Archived"
            ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Archived", Method: self.method)
        }
        
    }
    
    
    @IBOutlet weak var tbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.navigationController?.navigationBar.isHidden =  true
        ComonApi(FromDate: previousMonthStr, toDate: nextMonthStr, RequestNumver: "", Type: "Userview", Method: self.method)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }

    @IBAction func btn_filetr(_ sender: UIButton) {
        self.LoadFilterView()
    }
    
    @IBAction func btn_NewRequest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "RequititionFormVC")as! RequititionFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func ComonApi(FromDate:String,toDate:String,RequestNumver:String,Type:String,Method:String)
    {    let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        var parameters:[String:Any]?
         parameters =    ["CountryID":"","EmpCode":"","FromDate":FromDate,"Id":"","Mode":"","ReqType":"","RequestNo":RequestNumver,"ToDate":toDate,"TokenNo":token!,"Type":Type,"UserID":UserID!]
        Networkmanager.postRequestWithAlert(controller: self, vv: self.view, remainingUrl:Method, parameters: parameters!) { (response,data) in
            print(response)
            let status = response["Status"].intValue
            if status == 1
            {
                self.GetData = response["RequisitionList"]
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




//===========================================TableView And Cell======================================

extension TravelRequisitionVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TravelRequistationCell", for: indexPath) as! TravelRequistationCell
        cell.lbl_FromDate.text = GetData[indexPath.row]["FromDate"].stringValue
        cell.lbl_ToDate.text = GetData[indexPath.row]["ToDate"].stringValue
        cell.lbl_NaME.text = GetData[indexPath.row]["TravellerName"].stringValue
        cell.lbl_RmStatus.text = GetData[indexPath.row]["FinalStatus"].stringValue
        cell.Date.text = GetData[indexPath.row]["RequestDate"].stringValue
        cell.lbl_TourType.text = GetData[indexPath.row]["TravelType"].stringValue
        cell.lbl_RequestNumber.text = GetData[indexPath.row]["RequestNo"].stringValue
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequisitationDetailsVc")as! RequisitationDetailsVc
        vc.trID = GetData[indexPath.row]["TR_ID"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

class TravelRequistationCell:UITableViewCell{
    
    
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var lbl_RmStatus: UILabel!
    @IBOutlet weak var lbl_ToDate: UILabel!
    @IBOutlet weak var lbl_FromDate: UILabel!
    @IBOutlet weak var lbl_TourType: UILabel!
    @IBOutlet weak var lbl_NaME: UILabel!
    @IBOutlet weak var lbl_RequestNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
//======================================================================================================
extension TravelRequisitionVC
{
   func LoadFilterView()
    {
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "TravelRequisitionFilterVC") as! TravelRequisitionFilterVC
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        pvc.delegate = self
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
    }

}




extension TravelRequisitionVC:ReloadTableView {
    func ReloadApi(txt_Fromdate: String, txt_todate: String, txt_RequestNumber: String, txt_Empcide: String) {
        ComonApi(FromDate: txt_Fromdate, toDate: txt_todate, RequestNumver: txt_RequestNumber, Type: self.type, Method: self.method)
    }
    
   
    
    
   
}
