//
//  LogOutViewController.swift
//  NewOffNet
//
//  Created by Ankit Rana on 07/06/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class LogOutViewController: UIViewController {
var msg = ""
    var ok = ""
    var cancel = ""
    var titlee = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let alertController = UIAlertController(title:base.Title, message: "Are you sure you want to Exit?", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.pushToLoginVc()
            
        }
        let action1 = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        })
    
    
        // Add the actions
        alertController.addAction(okAction)
    alertController.addAction(action1)
        // Present the controller
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true)
        }
        
        
        
    }
    

  

    
    func pushToLoginVc()
    {       UserDefaults.standard.set("False", forKey: "IsLogin")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }

}
