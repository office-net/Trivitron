//
//  Notes_childVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 07/10/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import SemiModalViewController
protocol addnotes {
    func ab()
   
}
class Notes_childVC: UIViewController {
 
    @IBOutlet weak var txt_description: UITextField!
    var delegate:addnotes?
    var noteText = [String]()
    var DateText = [String]()
    
    @IBOutlet weak var btn_save: UIButton!
    var json:JSON  = []
    var isFromDummy = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
            let notetext =  defaults.stringArray(forKey: "notetext") ?? [String]()
            let Datetext =  defaults.stringArray(forKey: "datetext") ?? [String]()
        noteText = notetext
        DateText = Datetext
        self.txt_description.layer.borderWidth = 1
        self.txt_description.layer.borderColor = #colorLiteral(red: 0, green: 0.6775407791, blue: 0.2961367369, alpha: 1)

        
        // text field placeholder color chnager
        
        let color = UIColor.orange

        
        let placeholder2 = txt_description.placeholder ?? "" //There should be a placeholder set in storyboard or elsewhere string or pass empty
        txt_description.attributedPlaceholder = NSAttributedString(string: placeholder2, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        
        
        
        
    }
    func AddNoteAPI()
    {        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID,"Notes":self.txt_description.text ?? ""]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0","Notes":"Fufi"]
        }

        AF.request( base.url+"MyPage_DailyNotesSubmit", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters!)
                 switch response.result
                {
                
                case .success(let value):
                    
                    self.json =  JSON(value)
                    print(self.json)
                    let status = self.json["Status"].intValue
                    if status == 1 {
                        
                        let Message = self.json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                       if  let isLogin = UserDefaults.standard.object(forKey: "IsLogin") as? String{
                                if isLogin == "True"
                                {
                                    self.dismissSemiModalView()
                                    self.delegate?.ab()
                                }
                                else
                                    {
                                       let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let mainTabBarController = storyboard.instantiateViewController(identifier: "DummyNoteHome")
                                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                                    }
                                }
                            else
                            {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                 let mainTabBarController = storyboard.instantiateViewController(identifier: "DummyNoteHome")
                                 (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            }
                                
                            
                            
                         
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }else {
                        
                        let Message = self.json["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            //self.navigationController?.popViewController(animated: false)
                          
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            self.present(alertController, animated: true)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                
            }
        
        
        
        
            }

    @IBAction func btn_save(_ sender: Any) {
      let ab  =  UserDefaults.standard.object(forKey: "notee") as? Int
        if ab == 1
        {
            if txt_description.text == ""
            {
                let alert = UIAlertController(title: base.alertname, message: "Please Enter Description", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                
                let date = Date()
                let formatter1 = DateFormatter()
                formatter1.dateFormat = "HH:mm E, d MMM y"
                let fuldata = formatter1.string(from: date)
                DateText.append("\(fuldata)")
                noteText.append(txt_description.text!)
                let defaults = UserDefaults.standard
                defaults.set(noteText, forKey: "notetext")
                defaults.set(DateText, forKey: "datetext")
                
                self.delegate?.ab()
                self.dismissSemiModalView()
            }
        }
        else
        {
        if txt_description.text == ""
        {
            let alert = UIAlertController(title: base.alertname, message: "Please Enter Description", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
         else
         {
         AddNoteAPI()
         }
         }

    }
}
