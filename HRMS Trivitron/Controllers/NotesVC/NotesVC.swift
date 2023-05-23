//
//  NotesVC.swift
//  NewOffNet
//
//  Created by Netcomm Labs on 06/10/21.
//

import UIKit
import SemiModalViewController
import Alamofire
import SwiftyJSON

class NotesVC: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var btn_home: UIButton!
    @IBOutlet weak var view_home: UIView!
    @IBOutlet weak var tableView: UITableView!
    var noteData = 0
    var responseJson:JSON = []
    
    var senderTag = 0
    var Logindata = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_home.isHidden = true
        view_home.isHidden =  true
        NotesAPI()
        
        
        
    }

    
    
    @IBAction func btn_Home(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "DummyNoteHome")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    
    
    
    
    func NotesAPI()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)
        var parameters:[String:Any]?
        
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":UserID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","UserID":"0"]
        }
        AF.request( base.url+"MyPage_GetNotesList", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                    
                case .success(let value):
                    
                    self.responseJson =  JSON(value)
                    print(self.responseJson)
                    let status = self.responseJson["Status"].intValue
                    if status == 1
                    {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    else{
                        self.tableView.isHidden = true
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)
                        let msg  =  self.responseJson["Message"].stringValue
                        self.showAlert(message: msg)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
    }
    func MyPage_DailyNotesDeleteAPI(notesID:String)
    {
        
        var parameters:[String:Any]?
        
        if let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int {
            parameters =  ["TokenNo":"abcHkl7900@8Uyhkj","NotesID":notesID]
        }
        else{
            parameters = ["TokenNo":"abcHkl7900@8Uyhkj","NotesID":"0"]
        }
        AF.request( base.url+"MyPage_DailyNotesDelete", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.request!)
                print(parameters!)
                switch response.result
                {
                    
                case .success(let value):
                    
                    self.responseJson =  JSON(value)
                    print(self.responseJson)
                    
                    let status = self.responseJson["Status"].intValue
                    if status == 1 {
                        
                        let Message = self.responseJson["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            
                            self.responseJson.dictionaryObject?.removeValue(forKey: "\(self.senderTag)")
                            self.NotesAPI()
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        // Present the controller
                        DispatchQueue.main.async {
                            
                            self.present(alertController, animated: true)
                        }
                        
                    }else {
                        
                        let Message = self.responseJson["Message"].stringValue
                        // Create the alert controller
                        let alertController = UIAlertController(title: base.alertname, message: Message, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            self.tableView.reloadData()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return  self.responseJson["DailyNotesList"].arrayValue.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notetblcell")as! notetblcell
        let index = indexPath.row
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(btn_Delete(sender:)), for: .touchUpInside)
     
            cell.txt_note.text = responseJson["DailyNotesList"][index]["ShortNotes"].stringValue + responseJson["DailyNotesList"][index]["FullNotes"].stringValue
            cell.lbl_Date.text = responseJson["DailyNotesList"][index]["Date"].stringValue
            cell.lbl_title.text = responseJson["DailyNotesList"][index]["ShortNotes"].stringValue
        
     
        
        return cell
    }
    @objc func btn_Delete(sender : UIButton){
      
        print(sender.tag)
        senderTag = sender.tag
        
        let notesId = self.responseJson["DailyNotesList"][senderTag]["NotesID"].stringValue
        MyPage_DailyNotesDeleteAPI(notesID: notesId)
        
        
    }
    
    @IBAction func btn_addChild(_ sender: Any) {
        
        
        
        let options: [SemiModalOption : Any] = [
            SemiModalOption.pushParentBack: false
        ]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "Notes_childVC") as! Notes_childVC
        
        pvc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 520)
        
        pvc.modalPresentationStyle = .overCurrentContext
        pvc.delegate = self
        if self.Logindata == "True"
        {
            pvc.isFromDummy = false
        }
        //  pvc.transitioningDelegate = self
        
        presentSemiViewController(pvc, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
        })
        
    }
    
    
}







class notetblcell : UITableViewCell
{
    
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_Delete: UIButton!
    
    
    @IBOutlet weak var txt_note: UITextView!
    @IBAction func btn_delete(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        txt_note.layer.borderWidth = 0.5
        txt_note.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        txt_note.layer.cornerRadius = 5
        txt_note.isEditable = false
    }
    
}

extension NotesVC:addnotes
{
    func ab() {
     
            self.NotesAPI()
            
            self.dismissSemiModalView()
      
        
    }
    
    
}
