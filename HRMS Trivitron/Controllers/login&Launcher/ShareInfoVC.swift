//
//  ShareInfoVC.swift
//  NewOffNet
//
//  Created by Netcommlabs on 07/07/22.
//

import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON
class ShareInfoVC: UIViewController {
    @IBOutlet weak var txt_EmCode: UITextField!
    
    @IBOutlet weak var btn_Submit: UIButton!
    @IBOutlet weak var btn_checkBox: UIButton!
    @IBOutlet weak var txt_name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_check(_ sender: Any) {
        if btn_checkBox.isSelected == true
        {
            btn_checkBox.isSelected = false
        }
        else
        {
            btn_checkBox.isSelected = true
        }
    }
    

    @IBAction func btn_cancel(_ sender: Any) {
        self.dismissSemiModalView()
    }
    
    @IBAction func btnActionSUbmit(_ sender: Any) {
        if txt_name.text == ""
        {
            self.showAlert(message: "Please enter name")
        }
        else if txt_EmCode.text == ""
        {
            self.showAlert(message: "Please enter Emp Code")
        }
        else if btn_checkBox.isSelected == false
        {
            self.showAlert(message: "Please Select Check box for Continue")
        }
        else
        {
            self.Apicalling()
        }
    }
    
    
    
    
}


extension ShareInfoVC
{
    func Apicalling()
    {
        let deviceid = UIDevice.current.identifierForVendor!.uuidString
       
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        parameters = ["TokenNo":"abcHkl7900@8Uyhkj","Emp_Code":txt_EmCode.text ?? "","Emp_Name":txt_name.text ?? "","DeviceId":deviceid,"Additionaldeviceinformation":""]
        print(parameters!)
        AF.request(base.url+"DeviceIdUpdate", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of:JSON.self) { response in
                print( response.request!)
                print(parameters!)
                switch response.result
                {
                case .success(let value):
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                    let json:JSON = JSON(value)
                    print( json)
                   
                    let status = json["Status"].intValue
                    if status == 1
                    {
                        let msg = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.dismissSemiModalView()
                        }
                        alertController.addAction(okAction)
                        DispatchQueue.main.async {
                            
                        self.present(alertController, animated: true)
                        }
                    }
                    else
                    {
                        let msg = json["Message"].stringValue
                        let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                           // self.dismissSemiModalView()
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
