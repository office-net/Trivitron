//
//  LocalConveyanceVC.swift
//  user
//
//  Created by Netcomm Labs on 06/09/22.
//

import UIKit

class LocalConveyanceVC: UIViewController {

    @IBOutlet weak var segmentcontrol: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentcontrol.layer.backgroundColor = UIColor.white.cgColor
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }

    
    @IBAction func Backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_NewForm(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LocalConveyanceFormVC")as! LocalConveyanceFormVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
}
