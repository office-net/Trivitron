//
//  LauncherVC.swift
//  Myomax officenet
//
//  Created by Mohit Shrama on 29/06/20.
//  Copyright © 2020 Mohit Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

import SwiftGifOrigin
class LauncherVC: UIViewController {


    var isnote = true
    override func viewDidLoad() {
        super.viewDidLoad()
        apicalling()
        self.navigationController?.navigationBar.isHidden = true
   
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            
            if self.isnote
            {
                
                if  let isLogin = UserDefaults.standard.object(forKey: "IsLogin") as? String{
                    print("==========================  \(isLogin)")
                    if isLogin == "True"
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    }
                    else {
                        let defaults = UserDefaults.standard
                        defaults.set("English", forKey: "Language")
                        print("==========================  \(isLogin)")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    }
                }
                
                
                else {
                    
                    let defaults = UserDefaults.standard
                    defaults.set("English", forKey: "Language")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "DNotesVC")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            }
            
            
        }
        

     
    }
    

}


extension LauncherVC
{
    func apicalling()
    
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        let parameters = ["TokenNo": "abcHkl7900@8Uyhkj"]
        Networkmanager.postRequest(vv: self.view, remainingUrl:"RegistrationBtnStatus", parameters: parameters) { (response,data) in
            print("beforeeeeeee\(self.isnote)")
            
         //   self.isnote = response["ButtonStatus"].boolValue
        
            print("Afterrrrrrrr\(self.isnote)")
        }
 
    }
    
}
class GradienView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        let color1 = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let color2 = UIColor.white
        let color3 = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        gradientLayer.colors = [color1.cgColor,color2.cgColor,color3.cgColor]
    }
}

