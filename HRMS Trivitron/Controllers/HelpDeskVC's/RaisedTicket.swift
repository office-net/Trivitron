//
//  RaisedTicket.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 04/10/21.
//

import UIKit

class RaisedTicket: UIViewController,UITabBarDelegate,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var arrHelpDeskDetailsList = [] as NSMutableArray
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HelpDesk_GetDetailsAPI()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHelpDeskDetailsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath)as! tableviewcell
        if let dic = arrHelpDeskDetailsList[indexPath.row] as? NSDictionary {
            
            cell.lblTicket.text = dic.value(forKey: "TicketNo") as? String
            cell.lblDepartMent.text = dic.value(forKey: "Department") as? String
            cell.lblCategory.text = dic.value(forKey: "Category") as? String
            cell.lblSubCateGory.text = dic.value(forKey: "SubCategory") as? String
            cell.lblStatus.text = dic.value(forKey: "Status") as? String
            cell.lbl_Date.text = dic.value(forKey: "SubmissionDate") as? String
            cell.lbl_Priority.text = "Priority : \(String(describing: dic.value(forKey: "Priority") as? String)) "

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "HelpDeskViewRequestVC")as! HelpDeskViewRequestVC
         let dic = arrHelpDeskDetailsList[indexPath.row] as? NSDictionary
        vc.RequestId = (dic!.value(forKey: "ReqID") as? String)!
        vc.isfromRaisedTicket = true
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    func HelpDesk_GetDetailsAPI()   {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"StatusID":"%","Priority":"%"]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        //create the url with URL
        let url = URL(string: base.url+"HelpDesk_GetDetails")! //change the url
        //create the session object
        let session = URLSession.shared
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJlbmRlciI6Im5hbmRhbiIsImlhdCI6MTU4MDIwNTI5OH0.ATXxNeOUdiCmqQlCFf0ZxHoNA7g9NrCwqRDET6mVP7k", forHTTPHeaderField:"x-access-token" )
        
        
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                              DispatchQueue.main.async {
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                }
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    print(request)
                    print(parameters!)
                    
                    let status = json["Status"] as? Int
                    print(status as Any)
                    if status == 1 {
                        
                        self.arrHelpDeskDetailsList = (json["HelpDeskDetailsList"] as? NSMutableArray)!
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }else {
                        
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

}
class tableviewcell:UITableViewCell
{
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSubCateGory: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDepartMent: UILabel!
    @IBOutlet weak var lblTicket: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Priority: UILabel!
}

