//
//  PendingTicketVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 04/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
class PendingTicketVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var getdetails:JSON = []
    var previousMonthStr = ""
    var nextMonthStr = ""
    @IBOutlet weak var tblview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //+============+==========================GETING DATE +=================================================
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
        //==================================================================================================================
        serviceCall()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serviceCall()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getdetails.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcellpending", for: indexPath)as! tableviewcellpending
        cell.lblStatus.text = getdetails[indexPath.row]["Status"].stringValue
        cell.lblSubCateGory.text = getdetails[indexPath.row]["SubCategory"].stringValue
        cell.lblCategory.text  = getdetails[indexPath.row]["Category"].stringValue
        cell.lblDepartMent.text =  getdetails[indexPath.row]["Department"].stringValue
        cell.lblTicket.text = getdetails[indexPath.row]["TicketNo"].stringValue
        cell.lbl_Date.text  = getdetails[indexPath.row]["SubmissionDate"].stringValue
        cell.lbl_Priority.text = "Priority : " + getdetails[indexPath.row]["Priority"].stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HelpDeskViewRequestVC")as! HelpDeskViewRequestVC
        vc.RequestId = getdetails[indexPath.row]["ReqID"].stringValue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func serviceCall()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"StatusID":"%","CategoryID":"%","SubCategoryID":"%","SubmittedByID":"%","FromDate":previousMonthStr,"ToDate":nextMonthStr,"TicketNo":""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request(base.url+"HelpDesk_AdminRequestList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                case .success(let Value):
                    let json:JSON = JSON(Value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status  = json["Status"].intValue
                    if status == 1
                    { CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.getdetails = json["HelpDeskAdminList"]
                        self.tblview.reloadData()
                        
                    }
                    else
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        self.tblview.isHidden = true
                        let msg =  json["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        
    }
}
class tableviewcellpending:UITableViewCell
{
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSubCateGory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDepartMent: UILabel!
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Priority: UILabel!
}
