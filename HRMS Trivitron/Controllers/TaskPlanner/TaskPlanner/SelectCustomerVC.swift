//
//  SelectCustomerVC.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 26/09/22.
//

import UIKit
import SwiftyJSON


class SelectCustomerVC: UIViewController {
    @IBOutlet weak var tbl:UITableView!
    var GetData:JSON = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Customer" 
        tbl.delegate = self
        tbl.dataSource = self
        ApiCalling()
        // Do any additional setup after loading the view.
    }
    



}
extension SelectCustomerVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetData["CustomerBaselst"].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as!  SelectCell
        cell.index.text = "(\(indexPath.row))"
        cell.NaMe.text = GetData["CustomerBaselst"][indexPath.row]["CUSTOMER_NAME"].stringValue
        cell.status.text = GetData["CustomerBaselst"][indexPath.row]["ContactStatus"].stringValue
        if cell.status.text == "ACTIVE"
        {
            cell.vv.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.631372549, blue: 0.4980392157, alpha: 1)
            //59A17F
            
        }
        else
        {
            cell.vv.backgroundColor = UIColor.red
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "LedMain", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewTaskVC")as! NewTaskVC
        vc.CustomerData = GetData["CustomerBaselst"][indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SelectCustomerVC
{
    func ApiCalling()
    {     let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let parameters = ["TokenNo":token ?? "","UserId":UserID ?? 0] as [String : Any]
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"CustomerBaseList", parameters: parameters) { (response,data) in
            self.GetData = response
            let status = self.GetData["Status"].intValue
            if status == 1
            {
                print(self.GetData)
                self.tbl.reloadData()
              
            }
            else
            {
                let msg = self.GetData["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
    }
}




class SelectCell:UITableViewCell
{
    @IBOutlet weak var vv: UIView!
    @IBOutlet weak var index: UILabel!
    
    @IBOutlet weak var NaMe: UILabel!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var btn_Seelect: UIButton!
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func btn_select(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
