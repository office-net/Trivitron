//
//  TaskVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 11/07/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class TaskVC: UIViewController ,UITableViewDataSource,UITableViewDelegate, viewDetails, MarkMeeting{
    func didPressButton_MarkMeeting(with title: Int) {
     print("============================didPressButton_MarkMeeting\(title)")
    }
    
    func didPressButton_viewDetails(with title: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TasKDetailsVC")as! TasKDetailsVC
        vc.getdata = self.getData[title]
        vc.ADDITIONAL_PERSON = self.getData[title]["ADDITIONAL_PERSON"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var previousMonthStr = ""
    var nextMonthStr = ""
    var getData:JSON = []
    var filterd:JSON = []
    @IBOutlet weak var TBL: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        uisetup()
        apicalling()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)as! TaskCell
        cell.lbl_TaskName.text =  getData[indexPath.row]["CUSTOMER_NAME"].stringValue
       
        let dateString = getData[indexPath.row]["START_TIME"].stringValue
        let dateString2 = getData[indexPath.row]["END_TIME"].stringValue
        cell.lbl_Date.text = "\(getData[indexPath.row]["STARTS_DATE"].stringValue) \(dateString) To \(getData[indexPath.row]["END_DATE"].stringValue) \(dateString2)"
        let markMeetingStatus = getData[indexPath.row]["MarkMeetingOver"].intValue
        if markMeetingStatus == 1
        {
            cell.btn_MarkMeetingOver.isHidden = true
        }
        else
        {
            cell.btn_MarkMeetingOver.isHidden = false
        }
        
        cell.index =  indexPath.row
        cell.viewdetails = self
        cell.Merkmeeting = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    

}



protocol viewDetails:AnyObject {
    func didPressButton_viewDetails(with title:Int)
}
protocol MarkMeeting:AnyObject {
    func didPressButton_MarkMeeting(with title:Int)
}

class TaskCell:UITableViewCell
{
    @IBOutlet weak var btn_MarkMeetingOver: UIButton!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_TaskName: UILabel!
    @IBOutlet weak var btn_ViewDeatils: UIButton!
    var index:Int = 0
    weak var viewdetails: viewDetails?
    weak var Merkmeeting: MarkMeeting?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func btn_markMeeting(_ sender: Any) {
        Merkmeeting?.didPressButton_MarkMeeting(with: index)
       
    }
    
    @IBAction func btn_viewDetails(_ sender: Any) {
   
        viewdetails?.didPressButton_viewDetails(with: index)
        
    }
    
}


extension TaskVC
{
    func apicalling()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
         let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
     
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int  {
            parameters = ["TokenNo":token!,"UserId":UserID,"TaskId":"","Fromdate":previousMonthStr,"Todate":nextMonthStr]
          
        }
        else{
            parameters = ["TokenNo":"06736D3D-5E8B-491E-875C-255ED9A229A6","UserId":0]
        }
        
        AF.request( base.url+"TaskList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                                    print(response.request!)
                                   print(parameters!)
                switch response.result
                {
                case .success(let value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json2:JSON = JSON(value)
                    print(json2)

                    let status = json2["Status"].intValue
                    if status == 1
                    {
                        self.getData =  json2["TaskList"]
                        let jobj = json2["TaskList"].arrayValue
                       // print(jobj)
                        if !jobj.isEmpty {
                           let j = jobj.filter({ (json) -> Bool in
                               return json["MEETING_STATUS"].stringValue == "FIXED"; })
                           print ("filterdData: \(j)")
                        }
                       // self.filterd = self.getData.filter { $0["client_type_name"].stringValue.contains("Broker Dealer")  }
                        self.TBL.reloadData()
                    }
                    else
                    {
                        let msg = json2["Message"].stringValue
                        let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            
                        self.present(alertController, animated: true)
                        }
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        
        
        
    }
}


extension TaskVC
{
    func uisetup()
    {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        let PreviousMonth = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        
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
}
