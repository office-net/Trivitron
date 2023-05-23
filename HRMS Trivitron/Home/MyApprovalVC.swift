//  MyApprovalVC.swift
//  NewOffNet
//  Created by Ankit Rana on 17/08/22.

import UIKit
import Alamofire
import SwiftyJSON

class MyApprovalVC: UIViewController {

    @IBOutlet weak var btn_SL: Gradientbutton!
    @IBOutlet weak var btnCO: Gradientbutton!
    @IBOutlet weak var btn_Od: Gradientbutton!
    @IBOutlet weak var btn_Leave: Gradientbutton!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let defaults = UserDefaults.standard
        if let Language = defaults.string(forKey: "Language") {
            if Language == "English"
            {
                self.title = "  My Approvals"
                self.btn_Leave.setTitle("  Leave", for: .normal)
                self.btn_Od.setTitle("  Regularisation", for: .normal)
                self.btnCO.setTitle("  Comp Off", for: .normal)
                self.btn_SL.setTitle("  Short Leave", for: .normal)
            }
            else
            {
                self.title = "  मेरी स्वीकृति"
                self.btn_Leave.setTitle("  छुट्टी", for: .normal)
                self.btn_Od.setTitle("  नियमितीकरण", for: .normal)
                self.btnCO.setTitle("  कॉम्प ऑफ", for: .normal)
                self.btn_SL.setTitle("  कम व़क्त की छुट्टी", for: .normal)
            }
        }

    }
    
    @IBAction func btn_Leave(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingDetailVC")as! PendingDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_Ar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ODPendingRequestVC")as! ODPendingRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btn_ComOff(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "COPendingVC")as! COPendingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btn_ShortLeave(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SLPendingVC")as! SLPendingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
