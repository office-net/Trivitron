//
//  ConcludeTaskVC.swift
//  Maruti TMS
//
//  Created by Netcommlabs on 29/09/22.
//

import UIKit
import SwiftyJSON
import Foundation
protocol ConcludeAddtionalCellButton:AnyObject
{
    func BtnPressed()
    
}

protocol FillCvr:AnyObject
{
    func Action(CvrData:[String : Any])
}


class ConcludeTaskVC: UIViewController, FillCvr{
    
    
    
    func Action(CvrData: [String : Any]) {
        self.fillCVR = true
        self.btn_FilCrr.isSelected = true
       dict = CvrData
        print(dict)
    }
    
   
    var AdditionamDish = [[String:Any]]()
    var CompetitorDish = [[String:Any]]()
    var dict = [String:Any]()
    var fillCVR = false
    var markmeetingOver = false
    var imgString = ""

    var backData:JSON = []

    @IBOutlet weak var btnMarkMeet: UIButton!
    @IBOutlet weak var btn_FilCrr: UIButton!
    
    @IBOutlet weak var h2: NSLayoutConstraint!
    @IBOutlet weak var h1: NSLayoutConstraint!
    @IBOutlet weak var tbl2: UITableView!
    @IBOutlet weak var tbl1: UITableView!
    
    @IBOutlet weak var nameOfcompany: UITextField!
    
    @IBOutlet weak var nameofperson: UITextField!
    
    @IBOutlet weak var contactnumber: UITextField!
   
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var Reasion: UITextField!
    
    var AdditionalPersonCount = ["1"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(backData)
        self.title = "Conclude Task"
        tbl1.register(UINib(nibName: "ConcludeAddtionalCell", bundle: nil), forCellReuseIdentifier: "ConcludeAddtionalCell")
        tbl2.register(UINib(nibName: "CompetitorCell", bundle: nil), forCellReuseIdentifier: "CompetitorCell")
        uidetup()
        
    }
    
    
    @IBAction func btn_MarkMeeting(_ sender: Any) {
        callImagePicker()
    }
    
    @IBAction func btn_FillCvr(_ sender: Any) {
        if fillCVR == true
        {    self.btn_FilCrr.isSelected =  true
            self.showAlert(message: "Cvr Field")
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FillCvrDetails")as! FillCvrDetails
            vc.delegate = self
            vc.BackData = self.backData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func btn_Submit(_ sender: Any) {
        if markmeetingOver != true
        {
            self.showAlert(message: "Please Select Mark Meeting Over")
        }

        else
        {
            SubmitAPICalling()
        }
    }
    
    
    
    @IBAction func btn_Add(_ sender: Any) {
        
        if nameOfcompany.text == ""
        {
            self.showAlert(message: "Please ente name of compnay")
        }
        else if nameofperson.text == ""
        {
            self.showAlert(message: "Please ente name of person")
        }
        else
        {
            let dict = ["CompanyName": nameOfcompany.text ?? "",
                        "ContactNo": contactnumber.text ?? "",
                        "Email_Id": email.text ?? "",
                        "PersonName": nameofperson.text ?? "",
                        "Reason_visit": Reasion.text ?? ""]
            self.CompetitorDish.append(dict)
            self.tbl2.reloadData()
            nameOfcompany.text = ""
            contactnumber.text = ""
            email.text = ""
            nameofperson.text = ""
            Reasion.text = ""
            
            
        }
    }
    
    
    
    
}



extension ConcludeTaskVC
{
    func SubmitAPICalling()
    {

        
        let token  = UserDefaults.standard.object(forKey: "TokenNo") as? String
        let UserID = UserDefaults.standard.object(forKey: "UserID") as? Int
        let params:[String:Any] = [    "TokenNo": token!,
                                       "UserId": UserID!,
                                       "TaskId": backData["TaskId"].stringValue,
                                       "CompanyName": backData["COMPANY_NAME"].stringValue,
                                       "PERSON_NAME": backData["ContactPerson"].stringValue,
                                       "ContactNo": backData["CONTACT_NO"].stringValue,
                                       "ReasonOfVisit": "",
                                       "ImageExtension": "png",
                                       "markMeetingOver": markmeetingOver,
                                       "ADDITIONAL_PERSON": AdditionamDish,
                                       "CompetitorDetail": CompetitorDish,
                                       "CVRDetails": NSNull(),
                                       "Userselfieimage": imgString]
        
    
 
        
        Networkmanager.postRequest(vv: self.view, remainingUrl:"MarkMeetingover", parameters: params) { (response,data) in
            let json = response
            let status = json["Status"].intValue
            if status == 1
            {
                print(json)
                let msg = json["Message"].stringValue
                // Create the alert controller
                let alertController = UIAlertController(title: base.alertname, message: msg, preferredStyle: .alert)

                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                // Add the actions
                alertController.addAction(okAction)
                // Present the controller
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }

            }
            else
            {
                let msg = json["Message"].stringValue
                self.showAlert(message: msg)
            }
        }
      
    }
    func popToContact() {
        if let contactVC = self.navigationController?.viewControllers.filter({ $0 is HomeVC }).first {
            self.navigationController?.popToViewController(contactVC, animated: true)
        }
    }
}














extension ConcludeTaskVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl1
        {
            h1.constant = CGFloat(AdditionalPersonCount.count*0)
            return AdditionalPersonCount.count
        }
        else
        {
            h2.constant = CGFloat(CompetitorDish.count*110)
            return CompetitorDish.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConcludeAddtionalCell", for: indexPath) as! ConcludeAddtionalCell
            cell.delegate = self
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitorCell", for: indexPath) as! CompetitorCell
            cell.nameOftheompany.text = CompetitorDish[indexPath.row]["CompanyName"] as? String
            cell.btn_Delete.tag = indexPath.row
            cell.btn_Delete.addTarget(self, action: #selector(Competitiorbutton), for: .touchUpInside)
            return cell
        }
        
        
        
    }
    
    
    @objc func Competitiorbutton(_sender:UIButton)
    {
        CompetitorDish.remove(at: _sender.tag)
        tbl2.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  110
    }
    
    func uidetup()
    {
        tbl1.delegate = self
        tbl2.delegate = self
        tbl1.dataSource = self
        tbl2.dataSource = self
        tbl1.separatorStyle = .none
        tbl2.separatorStyle = .none
       
        
    }
    
}


extension ConcludeTaskVC:ConcludeAddtionalCellButton
{
    
    
    func BtnPressed() {
        self.AdditionalPersonCount.append("1")
        self.tbl1.reloadData()
    }
    
  
}











extension ConcludeTaskVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            //let imageData: Data? = imagePicked.jpegData(compressionQuality: 0.0)
            let imgData3 = imagePicked.jpegData(compressionQuality: 0.0)
          imgString = imgData3?.base64EncodedString(options: .lineLength64Characters) ?? ""
            self.btnMarkMeet.isSelected = true
            self.markmeetingOver = true
            
            print(imgString)
           // MyPage_UpdateProfilePicAPI()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func callImagePicker() {
        
        let imagePicker=UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let optionMenu = UIAlertController(title : nil , message: "Choose preferred source type", preferredStyle: UIAlertController.Style.actionSheet)
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        optionMenu.addAction(camera)
        optionMenu.addAction(UIAlertAction(title: "Photo Library", style: UIAlertAction.Style.default, handler: { action in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            action in
            optionMenu.dismiss(animated: true, completion: nil)}))
        self.present(optionMenu, animated: true, completion: nil)
    }
    
}
