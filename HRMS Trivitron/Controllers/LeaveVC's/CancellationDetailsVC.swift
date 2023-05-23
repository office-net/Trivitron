//
//  CancellationDetailsVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 05/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class CancellationDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoRequestToDisplay: UILabel!
    var previousMonthStr = ""
    var nextMonthStr = ""
    var strRequestId = "1"
    var arrGetDetails:JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.lblNoRequestToDisplay.text = "No Request To Display"
            }
            else
            {
                self.lblNoRequestToDisplay.text = "प्रदर्शित करने के लिए कोई अनुरोध नहीं है"
            }
        }
        self.view.layer.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        self.lblNoRequestToDisplay.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())
               let PreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
               
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

               print("strNextMonth",strNextMonth)
               print("strPreviousMonth",strPreviousMonth)
               
               LeaveUserCancelDetailsAPI()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGetDetails.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeavCancellationCell")as! LeavCancellationCell
        let index =  indexPath.row
        if arrGetDetails[index]["Leave_Name"].stringValue == ""
        {
            cell.lblStatus.text = "Undefined"
        }
        else
        {
            cell.lblStatus.text = arrGetDetails[index]["Leave_Name"].stringValue
        }
        
        cell.lblDate.text = arrGetDetails[index]["ReqNo"].stringValue
        cell.lblDateDiffrence.text = arrGetDetails[index]["Period"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        vc.dodo = arrGetDetails[indexPath.row]
        vc.btnstatus = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }

func LeaveUserCancelDetailsAPI()
{
    
    CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
    var parameters:[String:Any]?
    
    if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
    {
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"FromDate":previousMonthStr,"ToDate":nextMonthStr,"ReqTypeID":strRequestId,"ReqNo":""]
    }
    else{
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","PlantID":"0","Year":""]
    }
    
    
    AF.request( base.url+"LeaveUserCancelDetails"
, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        .responseJSON { response in
            switch response.result
            {
            
            case .success(let value):
                
                let json:JSON = JSON(value)
                print(json)
                print(response.request!)
                print(parameters!)
                let status = json["Status"].intValue
                if status == 1 {
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    self.arrGetDetails = json["objleaveGetDetailsRes"]
                    DispatchQueue.main.async {
                        self.lblNoRequestToDisplay.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }
                }else {
                    DispatchQueue.main.async {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.tableView.isHidden = true
                        self.lblNoRequestToDisplay.isHidden = false
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
            
        }
}

}

//MARK:-MenuTableViewCell
class LeavCancellationCell: UITableViewCell {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var tRequestCode: UILabel!
    @IBOutlet weak var TLeavePeriod: UILabel!
    
    @IBOutlet weak var lblDateDiffrence: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
        
                self.tRequestCode.text = "Request Code"
                self.TLeavePeriod.text = "Leave Period"
            }
            else
            {
                
                self.tRequestCode.text = "अनुरोध कोड"
                self.TLeavePeriod.text = "छुट्टी अवधि"
            }
        }

    }
}
