//
//  AbbrevationVC.swift
//  Myomax officenet
//
//  Created by admin on 08/03/21.
//  Copyright © 2021 Mohit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AbbrevationVC: UIViewController {
    
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var lbl_monthName: UILabel!
    @IBOutlet weak var btn_Preview: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var resData:JSON = []
    let dateFormatter = DateFormatter()
    let dateFormatterForApi  = DateFormatter()
    var dataDate:Date? = nil
    let currentDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        //=============================DATE FORMATTER=================
        dateFormatterForApi.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "MMMM YYYY"
        self.dataDate = currentDate
        let somedateString = dateFormatter.string(from: currentDate)
        self.lbl_monthName.text = somedateString
        let ApiDate = dateFormatterForApi.string(from: currentDate)
        self.apicall(date: ApiDate)
        let prefs = UserDefaults.standard
        let textToLoad = prefs.string(forKey: "ankit")
        print(textToLoad as Any)
    }
    
    
    @IBAction func btn_forword(_ sender: Any) {
        
        dateFormatterForApi.dateFormat = "yyyy-MM-dd"
         dateFormatter.dateFormat = "MMMM YYYY"
        let tomorrow = Calendar.current.date(byAdding: .month, value: 1, to: self.dataDate!)
        self.dataDate = tomorrow
        let somedateString = dateFormatter.string(from: tomorrow!)
        self.lbl_monthName.text = somedateString
        let ApiDate = dateFormatterForApi.string(from: tomorrow!)
        print(ApiDate)
        self.apicall(date: ApiDate)

    }
    
    
    @IBAction func btn_previous(_ sender: Any) {
        dateFormatterForApi.dateFormat = "yyyy-MM-dd"
         dateFormatter.dateFormat = "MMMM YYYY"
        let tomorrow = Calendar.current.date(byAdding: .month, value: -1, to: self.dataDate!)
        self.dataDate = tomorrow
        let somedateString = dateFormatter.string(from: tomorrow!)
        self.lbl_monthName.text = somedateString
        let ApiDate = dateFormatterForApi.string(from: tomorrow!)
        print(ApiDate)
        self.apicall(date: ApiDate)
    }

    func apicall(date:String)
    {
        
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":token!,"UserId":UserID,"Date":date]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserId":"0","Date":""]
        }
        AF.request(base.url+"GetMyAttendance", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result
                {
                 case .success(let value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(value)
                    print(json)
                    print(response.request!)
                    print(parameters!)
                    let status =  json["Status"].intValue
                    if status == 1
                    {
                        self.resData = json["MyAttendanceAbbreviationRes"]
                        self.tableView.reloadData()
                        if self.currentDate == self.dataDate
                        {
                            self.btn_Next.isHidden = true
                        }
                        else
                        {
                            self.btn_Next.isHidden = false
                        }
                        
                    }
                else
                    {
                        let Message = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: false)
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


extension AbbrevationVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resData.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AberCell") as! AberCell
        

        cell.lblLeft.text = resData[indexPath.row]["CalenderStatus"].stringValue + "( \(resData[indexPath.row]["AbbreviationDayCount"].stringValue) )"
        cell.lblRight.text = resData[indexPath.row]["ShortDesc"].stringValue
        
        let color = hexStringToUIColor(hex: resData[indexPath.row]["Color"].stringValue)
        cell.viewColor.backgroundColor = color
        cell.viewColor.layer.cornerRadius = 10
        cell.viewColor.layer.borderWidth = 1
        cell.viewColor.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewColor.circleView(borderColor:color, borderWidth: 0)

        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK:-MenuTableViewCell
class AberCell: UITableViewCell {
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
}


